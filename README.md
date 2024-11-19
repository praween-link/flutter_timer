
# timer_flutter

A versatile and developer-friendly Flutter package for creating and managing timers based on current DateTime. A timer with multiple listeners, synchronized with the current time. It supports millisecond updates, progress tracking (0 to 1), formatted time output, and timer status monitoring. As well time ago and time left.


## Timer Listeners

* `statusListener`: timer status listener `notStartedYet`, `started`, `ended`, `reset`, `clear`

* `timeListener`: formatted time listener `HH:MM:SS:ms`

* `millisecondsListener`: timer listener value in milliseconds

* `progress0to1Listener`: timer progress `0 to 1` listener


## Timer Controller

`TimerFController controller = TimerFController();`

* `controller.restart()`

* `controller.clear()`

* `controller.dispose()`

* `controller.controller.stream`: listen formatted time using [StreamBuilder](https://api.flutter.dev/flutter/widgets/StreamBuilder-class.html)

## Get Time Ago/Left

### Time Ago
```
final DateTime pastDateTime = DateTime.parse('2024-08-27 23:31:15.000');
String timeagoStr = TimeF.timeAgo(pastDateTime, formate: TimeAgoFormate(second: "## sec'# ago", week: "## week'# ago"), 
  listenerDateTimeF: (dtf) {
    log(" Ago DateTimeF Listener: ${dtf.toString()}"); // Ago DateTimeF Listener: DateTimeF(year: 0, month: 2, week: 3, day: 3, hour: 1, minute: 1, second: 10)
  });

log(timeagoStr); // 2 months ago
```

### Time Left
```
final DateTime futureDateTime = DateTime.parse('2024-11-26 23:31:15.000');
String timeExpireStr = TimeF.timeLeft(futureDateTime, formate: TimeLeftFormate(hour: "Offer expire in ## hour'#", day: "Offer expire in ## day'#"), 
  listenerDateTimeF: (dtf) {
    log("Left DateTimeF Listener: ${dtf.toString()}"); // Left DateTimeF Listener: DateTimeF(year: 0, month: 0, week: 0, day: 6, hour: 22, minute: 58, second: 49)
  });

log(timeExpireStr); // Offer expire in 6 days
```

### Formate
```
hour: "Offer expire in ## hour'#", // Result: Offer expire in 8 hours
```

```
month: "updated ## month'# ago", // Result: updated last 1 month ago
```

## Examples

```dart
late TimerFController _timerFController;
```

```dart
_timerFController = TimerFController(
    startTime: DateTime.now().add(
        const Duration(seconds: 18)), // --timer will be start after `18 sec`
    duration: const Duration(minutes: 8),
    timeFormate: "MM:SS:ms",
    listeningDelay: const Duration(milliseconds: 50),
    statusListener: (status) {
    log("timer: --status: $status");
    },
    reverce: false,
    millisecondsListener: (pms) {
    log("timer: --ms: $pms");
    },
    progress0to1Listener: (progress) {
    log("timer: --progress: $progress");
    },
    timeListener: (value) {
    log("timer: --time: $value");
    },
);
```

```dart
_timerFController.dispose();
```

```dart
StreamBuilder<String>(
    stream: _timerFController.controller.stream,
    builder: (context, snapshot) {
        if (snapshot.hasData) {
        return Text(snapshot.data ?? '',
            style: const TextStyle(color: Colors.black));
        } else {
        return const Text("not started",
            style: TextStyle(color: Colors.black));
        }
    }
),
```


## Usege
Simple demo of the timer_flutter package with full code

```
import 'dart:developer';

import 'package:flutter/material.dart';

import 'timer.dart';

class TimerDemo extends StatefulWidget {
  const TimerDemo({super.key});

  @override
  State<TimerDemo> createState() => _TimerDemoState();
}

class _TimerDemoState extends State<TimerDemo> {
  late TimerFController _timerFController;
  @override
  void initState() {
    super.initState();
    _timerFController = TimerFController(
      startTime: DateTime.now().add(
          const Duration(seconds: 18)), // --timer will be start after `18 sec`
      duration: const Duration(minutes: 8),
      timeFormate: "MM:SS:ms",
      listeningDelay: const Duration(milliseconds: 50),
      statusListener: (status) {
        log("timer: --status: $status");
      },
      reverce: false,
      millisecondsListener: (pms) {
        log("timer: --ms: $pms");
      },
      progress0to1Listener: (progress) {
        log("timer: --progress: $progress");
      },
      timeListener: (value) {
        log("timer: --time: $value");
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _timerFController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder<String>(
                stream: _timerFController.controller.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data ?? '',
                        style: const TextStyle(color: Colors.black));
                  } else {
                    return const Text("not started",
                        style: TextStyle(color: Colors.black));
                  }
                }),
            const SizedBox(height: 20),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _timerFController.restart();
                  },
                  child: const Text("reset"),
                ),
                ElevatedButton(
                  onPressed: () {
                    _timerFController.clear();
                  },
                  child: const Text("clear"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

```