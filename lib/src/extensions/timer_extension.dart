String _replayall(String time, (int, int, int, int) value) {
  time = time.replaceFirst("HH", value.$1.convertSingleDigitToDouble);
  time = time.replaceAll("MM", value.$2.convertSingleDigitToDouble);
  time = time.replaceAll("SS", value.$3.convertSingleDigitToDouble);
  time = time.replaceAll("ms", value.$4.convertSingleDigitToDouble);
  return time;
}

extension FtutterTimerExtension on int {
  String tFormate(String fs, Duration delay) {
    if (this <= 0) return _replayall(fs, (0, 0, 0, 0));
    final xd = Duration(milliseconds: this);
    final zero = DateTime(DateTime.now().year);

    final dateTime = zero.add(xd);

    var hour = dateTime.hour;
    var minute = dateTime.minute;
    var seconds = dateTime.second;
    var ms = dateTime.millisecond ~/ 10;
    return _replayall(fs, (hour, minute, seconds, ms));
  }

  String get convertSingleDigitToDouble =>
      toString().length == 1 ? "0${toString()}" : toString();
}
