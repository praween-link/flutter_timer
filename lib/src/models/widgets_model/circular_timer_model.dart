import 'package:flutter/material.dart';

import '../../../timer_flutter.dart';

class CircularTimerDecoraton {
  final List<Color>? progressColors;
  final MaskFilter? progressMaskFilter;
  final double prgressThickness;
  final Color? progressBackgroundColor;
  final ProgressShadow? progressShadow;
  final Color? fillColor;

  const CircularTimerDecoraton({
    this.progressColors,
    this.progressMaskFilter,
    this.prgressThickness = 8.0,
    this.progressBackgroundColor,
    this.progressShadow,
    this.fillColor,
  });
}

class TimerControllerValues {
  final DateTime? startTime;
  final Duration? duration;

  /// [timeFormate] => HH:MM:SS:ms
  final String? timeFormate;
  final Duration? listeningDelay;
  final bool isCountdown;
  final void Function(AppTimerStatus)? statusListener;
  final void Function(TimerFController)? controller;

  TimerControllerValues(
      {this.startTime,
      this.timeFormate,
      this.duration,
      this.listeningDelay,
      this.statusListener,
      this.isCountdown = true,
      this.controller});
}

class ProgressShadow {
  final Color color;
  final double opacity;
  final double blur;
  final double spreadRadius;
  ProgressShadow({
    this.color = Colors.blueGrey,
    this.opacity = 0.2,
    this.blur = 9.5,
    this.spreadRadius = 18,
  });
}
