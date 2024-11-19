import 'dart:async';

enum AppTimerStatus { notStartedYet, started, ended, reset, clear }

class TimerFController {
  /// [duration] it's duration of your timer
  Duration? duration;

  /// The [startTime] parameter allows you to set a specific time to start the timer.
  /// By default, it is set to the current time `DateTime.now()`.
  DateTime? startTime;

  /// The [timeFormate] is a string type that specifies the format for displaying time,
  /// and it is associated with a listener called [timeListener].
  String timeFormate;

  /// The [listeningDelay] parameter specifies the duration of the gap between
  /// each continus listener's `progress0to1Listener`, `millisecondsListener` and `timeListener`.
  Duration? listeningDelay;

  bool reverce;

  /// Timer status listener
  void Function(AppTimerStatus)? statusListener;

  /// Timer progress `0 to 1` listener
  void Function(double)? progress0to1Listener;

  /// Timer listener value in milliseconds
  void Function(int)? millisecondsListener;

  /// Time listener of value as string with formate
  void Function(String)? timeListener;

  TimerFController({
    this.startTime,
    this.duration,
    this.timeFormate = "HH:MM:SS:ms",
    this.listeningDelay,
    this.reverce = false,
    this.statusListener,
    this.progress0to1Listener,
    this.millisecondsListener,
    this.timeListener,
  }) {
    _startAddingNumbers();
  }

  /// -----------------------------------
  bool _isTimerStarted = false;
  bool _isTimerEnd = false;

  StreamController<String> _controller = StreamController<String>.broadcast();

  /// --Access by controller--
  // --get stream controller
  get controller => _controller;

  // --this function reset the timer
  restart() {
    _isTimerStarted = true;
    _isTimerEnd = false;
    startTime = DateTime.now();
    _startAddingNumbers();

    /// listener `statusListener`
    if (statusListener != null) {
      statusListener!(AppTimerStatus.reset);
    }
  }

  // --this function reset the timer
  clear() {
    _isTimerEnd = true;
    Duration delay = listeningDelay ?? const Duration(milliseconds: 100);
    _updateFormatedTimeString(0, delay);

    /// listener `statusListener`
    if (statusListener != null) {
      statusListener!(AppTimerStatus.ended);
      statusListener!(AppTimerStatus.clear);
    }
  }

  // dispose
  dispose() {
    _controller.close();
  }

  // ------------------------------------

  void _startAddingNumbers() async {
    Duration delay = listeningDelay ?? const Duration(milliseconds: 100);
    startTime ??= DateTime.now();

    /// listener `statusListener`
    if (statusListener != null) {
      statusListener!(AppTimerStatus.notStartedYet);
    }
    Timer.periodic(delay, (Timer timer) async {
      if (_isTimerEnd) {
        timer.cancel();
      }
      final DateTime current = DateTime.now();
      DateTime startedTime = startTime ?? DateTime.now();
      final DateTime end = startedTime.add(duration ?? const Duration(days: 1));
      final int maxMilisec = end.difference(startedTime).inMilliseconds;
      final int milisec = end.difference(current).inMilliseconds;

      /// listener `millisecondsListener`
      if (millisecondsListener != null && (_isTimerStarted && !_isTimerEnd)) {
        millisecondsListener!(milisec < 0 ? 0 : milisec);
      }

      /// listener `progress0to1Listener`
      if (progress0to1Listener != null && (_isTimerStarted && !_isTimerEnd)) {
        double per =
            ((milisec * 100) / end.difference(startedTime).inMilliseconds) /
                100;

        if (per <= 100 && per >= 0) {
          /// --added reverce timer progress condition
          if (reverce) {
            progress0to1Listener!(1 - per);
          } else {
            progress0to1Listener!(per);
          }
        }
      }

      if (_timerStart(current: current, start: startedTime)) {
        if (_controller.isClosed) {
          _controller = StreamController<String>();
        }

        /// --added reverce timer condition
        if (reverce) {
          _updateFormatedTimeString(maxMilisec - milisec, delay);
        } else {
          _updateFormatedTimeString(milisec, delay);
        }
      }
      _timerStartChangeStatus(current: current, start: startedTime);

      /// --end timer
      if (milisec <= 0) {
        _updateFormatedTimeString(0, delay);
        timer.cancel();
        _controller.close();
      }
    });
  }

  _updateFormatedTimeString(int milisec, delay) {
    if (_isTimerStarted && !_isTimerEnd) {
      _controller.sink.add(milisec.tFormate(timeFormate, delay));

      /// listener `timeListener`
      if (timeListener != null) {
        timeListener!(milisec.tFormate(timeFormate, delay));
      }
    } else {
      _controller.sink.add(0.tFormate(timeFormate, delay));

      /// listener `timeListener`
      if (timeListener != null) {
        timeListener!(0.tFormate(timeFormate, delay));
      }
    }
  }

  void _timerStartChangeStatus(
      {required DateTime current, required DateTime start}) {
    Duration currentDuration = duration ?? const Duration(days: 1);
    final DateTime end = start.add(currentDuration);
    final int milisec = end.difference(current).inMilliseconds;
    final int milisec2 = current.difference(start).inMilliseconds;

    if (milisec <= 0) {
      /// listener `statusListener`
      if (statusListener != null) {
        statusListener!(AppTimerStatus.ended);
      }
      _isTimerEnd = true;
    } else if (milisec2 > 0) {
      if (!_isTimerStarted) {
        /// listener `statusListener`
        if (statusListener != null) {
          statusListener!(AppTimerStatus.started);
        }
        _isTimerStarted = true;
      }
    }
  }

  bool _timerStart({required DateTime current, required DateTime start}) {
    final status = current.difference(start).inMilliseconds;
    return status >= 0;
  }
}

extension FtutterTimerExtension on int {
  String tFormate(String fs, Duration delay) {
    if (this <= 0) return replayall(fs, (0, 0, 0, 0));
    final xd = Duration(milliseconds: this);
    final zero = DateTime(DateTime.now().year);

    final dateTime = zero.add(xd);

    var hour = dateTime.hour;
    var minute = dateTime.minute;
    var seconds = dateTime.second;
    var ms = dateTime.millisecond ~/ 10;
    return replayall(fs, (hour, minute, seconds, ms));
  }

  String get convertSingleDigitToDouble =>
      toString().length == 1 ? "0${toString()}" : toString();
}

String replayall(String time, (int, int, int, int) value) {
  time = time.replaceFirst("HH", value.$1.convertSingleDigitToDouble);
  time = time.replaceAll("MM", value.$2.convertSingleDigitToDouble);
  time = time.replaceAll("SS", value.$3.convertSingleDigitToDouble);
  time = time.replaceAll("ms", value.$4.convertSingleDigitToDouble);
  return time;
}
