import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'poc audio'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, this.title});

  final String? title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  AudioPlayer player = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  Record audioRecord = Record();
  bool isRecording = false;
  bool isPaused = false;
  File? audioPath;

  Stream<int>? timerStream;
  StreamSubscription<int>? timerSubscription;
  String minutesStr = '00';
  String secondsStr = '00';
  int elapsedSeconds = 0;

  Stream<int> stopWatchStream() {
    StreamController<int>? streamController;
    Timer? timer;
    Duration timerInterval = const Duration(seconds: 1);
    int counter = 0;

    void stopTimer() {
      if (timer != null) {
        timer!.cancel();
        timer = null;
        counter = 0;
        streamController!.close();
      }
    }

    void tick(_) {
      counter++;
      streamController!.add(counter);
    }

    void startTimer() {
      timer = Timer.periodic(timerInterval, tick);
    }

    streamController = StreamController<int>(
      onListen: startTimer,
      onCancel: stopTimer,
      onResume: startTimer,
      onPause: stopTimer,
    );

    return streamController.stream;
  }

  Future<void> startRecording() async {
    await player.stop();
    if (await audioRecord.hasPermission()) {
      await audioRecord.start();
      setState(() {
        isRecording = true;
        timerStream = stopWatchStream();
        timerSubscription = timerStream!.listen((int newTick) {
          setState(() {
            minutesStr =
                ((newTick / 60) % 60).floor().toString().padLeft(2, '0');
            secondsStr = (newTick % 60).floor().toString().padLeft(2, '0');
          });
        });
      });
    }
  }

  Future<void> pauseRecording() async {
    await audioRecord.pause();
    timerSubscription?.pause();
    setState(() {
      isRecording = false;
      isPaused = true;
    });
  }

  Future<void> resumeRecording() async {
    await audioRecord.resume();
    timerSubscription?.resume();
    setState(() {
      isRecording = true;
      isPaused = false;
      timerStream = stopWatchStream();
      int lastMinute = int.parse(minutesStr);
      int lastSecond = int.parse(secondsStr);
      timerSubscription = timerStream!.listen((int newTick) {
        setState(() {
          minutesStr = (((lastMinute + newTick) / 60) % 60)
              .floor()
              .toString()
              .padLeft(2, '0');
          secondsStr =
              ((lastSecond + newTick) % 60).floor().toString().padLeft(2, '0');
        });
      });
    });
  }

  Future<void> stopRecording() async {
    String? path = await audioRecord.stop();
    setState(() {
      isRecording = false;
      timerSubscription!.cancel();
      timerStream = null;
      setState(() {
        minutesStr = '00';
        secondsStr = '00';
      });
      audioPath = File(path!);
      setAudio();
    });
  }

  String formatTime(Duration duration) {
    String twoDigit(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigit(duration.inHours);
    final minutes = twoDigit(duration.inMinutes.remainder(60));
    final seconds = twoDigit(duration.inSeconds.remainder(60));

    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }

  @override
  void initState() {
    player.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });

    player.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    player.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });

    super.initState();
  }

  Future setAudio() async {
    player.setReleaseMode(ReleaseMode.stop);
    await player.stop();
    if (audioPath == null) {
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.any);

      if (result != null) {
        final file = File(result.files.single.path!);
        var urlSource = DeviceFileSource(file.path);
        player.setSource(urlSource);
      }
    } else {
      player.setSourceUrl(audioPath!.path);
    }
  }

  Future setAudioFromUrl() async {
    player.setReleaseMode(ReleaseMode.stop);
    await player.stop();
    String url =
        "http://commondatastorage.googleapis.com/codeskulptor-assets/week7-button.m4a";
    await player.setSourceUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title!),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 5.0,
                    spreadRadius: -1.0,
                    offset: Offset(
                      2.0,
                      1.5,
                    ),
                  )
                ],
              ),
              child: Center(
                child: Column(
                  children: [
                    const Text('Record your sound'),
                    const SizedBox(
                      height: 10,
                    ),
                    if (isRecording) const Text('recording in progress'),
                    if (isPaused) const Text('enregistrement en pause'),
                    const SizedBox(
                      height: 10,
                    ),
                    Text("$minutesStr:$secondsStr"),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const Spacer(),
                        ElevatedButton(
                            onPressed: () {
                              isPaused ? resumeRecording() : pauseRecording();
                            },
                            child: Icon(
                                isPaused ? Icons.play_arrow : Icons.pause)),
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            isRecording ? stopRecording() : startRecording();
                          },
                          child: Text(isRecording
                              ? 'Arrêter l\'enregistrement'
                              : 'Démarrer l\'enregistrement'),
                        ),
                        const Spacer(),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 5.0,
                    spreadRadius: -1.0,
                    offset: Offset(
                      2.0,
                      1.5,
                    ),
                  )
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  const Text('Listen your audio'),
                  const SizedBox(
                    height: 10,
                  ),
                  Slider(
                      min: 0,
                      max: duration.inMilliseconds.toDouble(),
                      value: position.inMilliseconds.toDouble(),
                      onChanged: (value) async {
                        final position = Duration(milliseconds: value.toInt());
                        await player.seek(position);
                        await player.resume();
                      }),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Text(formatTime(position)),
                        const Spacer(),
                        Text(formatTime(duration)),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Spacer(),
                      IconButton(
                          onPressed: () async {
                            if (isPlaying) {
                              await player.pause();
                            } else {
                              await player.resume();
                            }
                          },
                          icon:
                              Icon(isPlaying ? Icons.pause : Icons.play_arrow)),
                      IconButton(
                          onPressed: () async {
                            player.stop();
                          },
                          icon: const Icon(Icons.stop)),
                      Spacer(),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
      floatingActionButton: Row(
        children: [
          const Spacer(),
          FloatingActionButton(
            onPressed: () {
              audioPath = null;
              setAudioFromUrl();
            },
            tooltip: 'Increment',
            child: const Icon(Icons.music_note),
          ),
          const SizedBox(
            width: 20,
          ),
          FloatingActionButton(
            onPressed: () {
              audioPath = null;
              setAudio();
            },
            tooltip: 'Increment',
            child: const Icon(Icons.change_circle),
          ),
        ],
      ),
    );
  }
}
