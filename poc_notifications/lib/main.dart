import 'package:flutter/material.dart';
import 'package:poc_meysso3/notification_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final NotificationService notificationService;

  @override
  void initState() {
    notificationService = NotificationService();
    // listenToNotificationStream();
    notificationService.initializePlatformNotifications();
    super.initState();
  }

  /*void listenToNotificationStream() =>
      notificationService.behaviorSubject.listen((payload) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MySecondScreen(payload: payload)));
      });*/

  @override
  Widget build(BuildContext context) {
    int counter = 1;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: /*Stack(
          children: [
            Positioned(
              bottom: 30,
                right: 30,
                child: ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.teal),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                          side: const BorderSide(color: Colors.black)))),
              child: const Icon(Icons.add, color: Colors.white, size: 30, ),
            ))
          ],
        )
*/
        Center(
            child: Column(
              children: [
                const Spacer(),
                ElevatedButton(
                  onPressed: () async {
                    print(counter);
                    await notificationService.showLocalNotification(
                        id: counter,
                        title: "Instant notification",
                        body: "instant",
                        payload: "first");
                    counter++;
                  },

                  child: const Text("Send notification"),
                ),

                ElevatedButton(
                    onPressed: () async {
                      await notificationService.showScheduleLocalNotification(
                          id: counter,
                          title: "Scheduled notification",
                          body: "with delay of 10 seconds",
                          payload: "first",
                          seconds: 10);
                      counter++;
                    },
                    child: const Text("Schedule Drink")),

                ElevatedButton(
                    onPressed: () async {
                      print(counter);
                      await notificationService.showPeriodicLocalNotification(
                          id: counter,
                          title: "Periodic notification",
                          body: "Every minutes",
                          payload: "first",
                        repeat: "minute"
                      );
                      counter++;
                    },
                    child: const Text("Every minute")),

                ElevatedButton(
                    onPressed: () async {
                      notificationService.cancelAllNotifications();
                    },
                    child: const Text("Cancel notification")),
                const Spacer(),
              ],
            ))
        );
  }
}
