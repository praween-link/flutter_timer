import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:timer_flutter/timer_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Timer Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TimerFlutterDemo(),
    );
  }
}

class TimerFlutterDemo extends StatefulWidget {
  const TimerFlutterDemo({super.key});

  @override
  State<TimerFlutterDemo> createState() => _TimerFlutterDemoState();
}

class _TimerFlutterDemoState extends State<TimerFlutterDemo> {
  late TimerFController timerFController;
  late TimerFController timerFController2;

  @override
  void initState() {
    super.initState();
    timerFController2 = TimerFController(
      timeFormate: "HH:MM:SS:ms",
      duration: const Duration(hours: 18),
    );
  }

  @override
  void dispose() {
    timerFController.dispose();
    timerFController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  StreamBuilder(
                    stream: timerFController2.controller.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text("${snapshot.data ?? ''}",
                            style: const TextStyle(
                                color: Colors.black, fontSize: 18));
                      } else {
                        return const Text("not started",
                            style: TextStyle(color: Colors.black));
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      timerFController2.restart();
                    },
                    child: const Text("reset"),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              FlutterCircularProgressTimer(
                isPieShape: false,
                timerControllerValues: TimerControllerValues(
                    listeningDelay: const Duration(milliseconds: 100),
                    timeFormate: "MM:SS",
                    isCountdown: true,
                    duration: const Duration(minutes: 5),
                    statusListener: (status) {
                      log("Timer status: $status");
                    },
                    controller: (controller) {
                      timerFController = controller;
                    }),
                radius: 60,
                decoraton: CircularTimerDecoraton(
                  fillColor: Colors.transparent,
                  progressBackgroundColor: Colors.grey.withValues(alpha: 0.2),
                  prgressThickness: 12,
                  progressMaskFilter:
                      const MaskFilter.blur(BlurStyle.inner, 11.5),
                  progressColors: const [Colors.blue],
                  // progressShadow: ProgressShadow(
                  //     color: Colors.red, opacity: 0.5, blur: 9.8, spreadRadius: 18),
                ),
                builder: (BuildContext context, value, progress) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        value ?? '',
                        style: const TextStyle(
                          fontSize: 38,
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const Text(
                        "minutes",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 18),
              ElevatedButton(
                onPressed: () {
                  timerFController2.restart();
                },
                child: const Text("reset"),
              ),
              const Divider(),

              /// --Time Ago
              Text(
                _getTimeAgo(),
                style: const TextStyle(color: Colors.black, fontSize: 18),
              ),

              /// --Time Left
              Text(
                _getTimeLeft(),
                style: const TextStyle(color: Colors.black, fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getTimeAgo() {
    final DateTime pastDateTime =
        DateTime.now().subtract(const Duration(minutes: 1890));
    String timeagoStr = TimeF.timeAgo(pastDateTime,
        formate: TimeAgoFormate(second: "## sec'# ago", week: "## week'# ago"),
        listenerDateTimeF: (dtf) {
      log(" Ago DateTimeF Listener: ${dtf.toString()}"); // Ago DateTimeF Listener: DateTimeF(year: 0, month: 2, week: 3, day: 3, hour: 1, minute: 1, second: 10)
    });
    return timeagoStr;
  }

  String _getTimeLeft() {
    final DateTime pastDateTime = DateTime.now().add(const Duration(days: 18));
    String timeagoStr = TimeF.timeLeft(pastDateTime,
        formate: TimeLeftFormate(
            second: "expire in ## sec'#",
            week: "expire in ## week'#",
            day: "expire in ## day'#"), listenerDateTimeF: (dtf) {
      log(" Ago DateTimeF Listener: ${dtf.toString()}"); // Ago DateTimeF Listener: DateTimeF(year: 0, month: 2, week: 3, day: 3, hour: 1, minute: 1, second: 10)
    });
    return timeagoStr;
  }
}
