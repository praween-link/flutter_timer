import 'dart:async';

import 'extensions/imports.dart';

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

  bool isCountdown;

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
    this.isCountdown = true,
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
    startTime = DateTime.now().add(listeningDelay ?? defaultDelay);
    _startAddingNumbers();

    /// listener `statusListener`
    if (statusListener != null) {
      statusListener!(AppTimerStatus.reset);
    }
  }

  // --this function reset the timer
  clear() {
    _isTimerEnd = true;
    Duration delay = listeningDelay ?? defaultDelay;
    _updateFormatedTimeString(0, delay, isCountdown);
    if (progress0to1Listener != null) {
      progress0to1Listener!(0);
    }

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
  Duration defaultDelay = const Duration(milliseconds: 50);

  void _startAddingNumbers() async {
    Duration delay = listeningDelay ?? defaultDelay;
    startTime ??= DateTime.now().add(delay);

    /// listener `statusListener`
    if (statusListener != null) {
      statusListener!(AppTimerStatus.notStartedYet);
    }
    Timer.periodic(delay, (Timer timer) async {
      if (_isTimerEnd) {
        timer.cancel();
      }
      final DateTime current = DateTime.now();
      DateTime startedTime = (startTime ?? DateTime.now()).add(delay);
      final DateTime end = startedTime.add(duration ?? const Duration(days: 1));
      final int maxMilisec = end.difference(startedTime).inMilliseconds;
      final int milisec = end.difference(current).inMilliseconds;

      /// listener `millisecondsListener`
      if (millisecondsListener != null && (_isTimerStarted && !_isTimerEnd)) {
        millisecondsListener!(milisec < 0 ? 0 : milisec);
      }

      /// listener `progress0to1Listener`
      _progress0to1ListenerUpdate(
          end, startedTime, milisec, (_isTimerStarted && !_isTimerEnd));

      if (_timerStart(current: current, start: startedTime)) {
        if (_controller.isClosed) {
          _controller = StreamController<String>();
        }

        /// --added reverce timer condition
        if (isCountdown) {
          _updateFormatedTimeString(milisec, delay, isCountdown);
        } else {
          _updateFormatedTimeString(maxMilisec - milisec, delay, isCountdown);
        }
      }
      _timerStartChangeStatus(current: current, start: startedTime);

      /// --end timer
      if (milisec <= 0) {
        _updateFormatedTimeString(10, delay, isCountdown);
        timer.cancel();
      }
    });
  }

  _progress0to1ListenerUpdate(
      DateTime end, DateTime startedTime, int milisec, bool runing) {
    if (progress0to1Listener != null && runing) {
      double per =
          ((milisec * 100) / end.difference(startedTime).inMilliseconds) / 100;
      if (per <= 100 && per >= 0) {
        /// --added countdown timer progress condition
        if (isCountdown) {
          progress0to1Listener!(per);
        } else {
          progress0to1Listener!(1 - per);
        }
      } else {
        progress0to1Listener!(isCountdown ? 0 : 1);
      }
    }
  }

  _updateFormatedTimeString(int milisec, delay, bool isCountdown) {
    if (_isTimerStarted && !_isTimerEnd) {
      _controller.sink.add(milisec.tFormate(timeFormate, delay));

      /// listener `timeListener`
      if (timeListener != null) {
        timeListener!(milisec.tFormate(timeFormate, delay));
      }
    } else {
      if (!isCountdown) return;
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
          if (progress0to1Listener != null) {
            progress0to1Listener!(isCountdown ? 1 : 0);
          }
          _controller.sink.add((isCountdown ? milisec : milisec2)
              .tFormate(timeFormate, listeningDelay ?? defaultDelay));
          //
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
