import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationService {
  NotificationService();

  final localNotifications = FlutterLocalNotificationsPlugin();
  int id = 1;

  // final BehaviorSubject<String> behaviorSubject = BehaviorSubject();

  Future<void> initializePlatformNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_notification_icon');

    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
            requestSoundPermission: true,
            requestBadgePermission: true,
            requestAlertPermission: true,
            onDidReceiveLocalNotification: onDidReceiveLocalNotification,
            notificationCategories: darwinNotificationCategories);

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    tz.initializeTimeZones();
    tz.setLocalLocation(
      tz.getLocation(await FlutterTimezone.getLocalTimezone()),
    );

    await localNotifications.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onNotificationClick);

    AndroidNotificationChannelGroup channelGroup =
        const AndroidNotificationChannelGroup(
            'com.my.app.alert1', 'mychannel1');
    await localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannelGroup(channelGroup);
  }

  DarwinNotificationDetails iosNotificationDetails =
  const DarwinNotificationDetails(
    categoryIdentifier: 'group',
  );

  final List<DarwinNotificationCategory> darwinNotificationCategories =
  <DarwinNotificationCategory>[
  DarwinNotificationCategory('group', actions: <DarwinNotificationAction>[
    DarwinNotificationAction.plain(
      'reminder',
      'Reminder',
      options: <DarwinNotificationActionOption>{
        DarwinNotificationActionOption.foreground,
      },
    ),
  ] )
  ];


  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {
    print('id $id');

  }

  Future<NotificationDetails> notificationDetails() async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        const AndroidNotificationDetails('channel id', 'channel name',
            groupKey: 'group',
            channelDescription: 'channel description',
            importance: Importance.max,
            priority: Priority.max,
            playSound: true,
            actions: [
          AndroidNotificationAction('reminder', 'Reminder',
              showsUserInterface: true)
        ]);
    DarwinNotificationDetails iosNotificationDetails =
        const DarwinNotificationDetails(
      categoryIdentifier: "group",
    );

    return NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iosNotificationDetails);
  }

  /// action for reminder button on notification

  Future<void> onNotificationClick(NotificationResponse response) async {
    debugPrint(" response ------> ${response.actionId}");
    debugPrint(
        "input ---> ${response.input}, "
            "id ----> ${response.id}, payload -----> ${response.payload}, "
            "responseNotification --> ${response.notificationResponseType.toString()}");

    if (response.actionId == "reminder") {
      await showScheduleLocalNotification(
          id: response.id,
          title: "Reminder",
          body: "this is the reminder",
          payload: "first",
          seconds: 2);
    }
  }

  /// Show notification group

  getGroupnotifier() {
    InboxStyleInformation inboxStyleInformation = InboxStyleInformation([],
        contentTitle: '$id messages', summaryText: 'group');
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('channelId', 'channelName',
            styleInformation: inboxStyleInformation,
            groupKey: 'group',
            playSound: true,
            setAsGroupSummary: true,
            actions: [
          const AndroidNotificationAction('reminder', 'Reminder',
              showsUserInterface: true)
        ]);

    return NotificationDetails(android: androidPlatformChannelSpecifics);
  }

  /// local notification
  /// immediately

  Future<void> showLocalNotification({
    required int id,
    required String title,
    required String body,
    required String payload,
  }) async {
    final notificationDetail = await notificationDetails();
    await localNotifications.show(
      id,
      title,
      body,
      notificationDetail,
    );

    if(Platform.isAndroid) {
      NotificationDetails groupNotification = getGroupnotifier();
      await localNotifications.show(
          0, 'Meysso', '$id messages', groupNotification);
    }

  }

  /// schedule notification
  Future<void> showScheduleLocalNotification({
    required int? id,
    required String title,
    required String body,
    required String payload,
    required int seconds,
  }) async {
    final platformChannelSpecifics = await notificationDetails();
    await localNotifications.zonedSchedule(
      id!,
      title,
      body,
      tz.TZDateTime.now(tz.local).add(Duration(seconds: seconds)),
      platformChannelSpecifics,
      payload: payload,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );

    if(Platform.isAndroid) {
      NotificationDetails groupNotification = getGroupnotifier();
      await localNotifications.show(
          0, 'Meysso', '$id messages', groupNotification);
    }
  }

  /// periodically notification
  Future<void> showPeriodicLocalNotification({
    required int id,
    required String title,
    required String body,
    required String payload,
    required String repeat,
  }) async {
    final platformChannelSpecifics = await notificationDetails();
    await localNotifications.periodicallyShow(
      id,
      title,
      body,
      convertStringIntoRepeatInterval(repeat),
      platformChannelSpecifics,
      payload: payload,
    );

    if(Platform.isAndroid) {
      NotificationDetails groupNotification = getGroupnotifier();
      await localNotifications.show(
          0, 'Meysso', '$id messages', groupNotification);
    }
  }

  /// cancel notification
  void cancelSingleNotifications() => localNotifications.cancel(0);

  void cancelAllNotifications() => localNotifications.cancelAll();

  convertStringIntoRepeatInterval(String repeat) {
    switch(repeat) {
      case "minute":
        return RepeatInterval.everyMinute;
      case "hour":
        return RepeatInterval.hourly;
      case "daily":
        return RepeatInterval.daily;
      case "weekly":
        return RepeatInterval.weekly;
      default:
        return RepeatInterval.everyMinute;
    }
  }

}
