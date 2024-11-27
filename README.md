
# timer_flutter

A versatile and developer-friendly Flutter package for creating and managing timers based on current DateTime. A timer with multiple listeners, synchronized with the current time. It supports millisecond updates, `progress tracking (0 to 1)`, formatted time output, and `timer status` monitoring, circular timer widgets `circular progress` and `pie`. As well as `time ago` and `time left`.

<div style="text-align: center">
    <table>
        <tr>
            <td style="text-align: center">
                <img src="https://github.com/praween-link/flutter_timer/blob/main/assets/timer_with_pie.gif" width="200"/>
            </td>            
            <td style="text-align: center">
                <img src="https://github.com/praween-link/flutter_timer/blob/main/assets/timer_with_progress.gif" width="200"/>
            </td>
            <td style="text-align: center">
                <img src="https://github.com/praween-link/flutter_timer/blob/main/assets/timer_with_text.gif" width="200" />
            </td>
        </tr>
    </table>
</div>

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
    isCountdown: true,
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

## Circular `progress` and `pie` type timer widget builder

```
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
    progressBackgroundColor: Colors.grey.withAlpha((255.0 * 0.2).round()),
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
```
