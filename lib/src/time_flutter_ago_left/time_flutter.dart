part of 'imports.dart';

class TimeF {
  TimeF._();

  static timeAgo(
    DateTime dateTime, {
    TimeAgoFormate? formate,
    void Function(DateTimeF)? listenerDateTimeF,
  }) {
    return TimeFAgo.timeAgo(
      dateTime,
      formate: formate,
      listenerDateTimeF: listenerDateTimeF,
    );
  }

  static timeLeft(
    DateTime dateTime, {
    TimeLeftFormate? formate,
    void Function(DateTimeF)? listenerDateTimeF,
  }) {
    return TimeFLeft.timeLeft(
      dateTime,
      formate: formate,
      listenerDateTimeF: listenerDateTimeF,
    );
  }
}
