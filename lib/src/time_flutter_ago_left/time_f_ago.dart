import 'time_flutter.dart';

class TimeFAgo {
  TimeFAgo._();

  static String timeAgo(DateTime dateTime,
      {TimeAgoFormate? formate, void Function(DateTimeF)? listenerDateTimeF}) {
    final Duration difference = DateTime.now().difference(dateTime);

    DateTimeF dateTimeF = getTimeAgoConvertedDateTimeF(dateTime);
    if (listenerDateTimeF != null) {
      listenerDateTimeF(dateTimeF);
    }

    if (difference.inSeconds < 60) {
      return formate.toSecoundFormateString.leftAlgoFm(difference.inSeconds);
    } else if (difference.inMinutes < 60) {
      return formate.toMinuteFormateString.leftAlgoFm(difference.inMinutes);
    } else if (difference.inHours < 24) {
      return formate.toHourFormateString.leftAlgoFm(difference.inHours);
    } else if (difference.inDays < 7) {
      return formate.toDayFormateString.leftAlgoFm(difference.inDays);
    } else if (difference.inDays < 30) {
      return formate.toWeekFormateString.leftAlgoFm(dateTimeF.week);
    } else if (difference.inDays < 365) {
      return formate.toMonthFormateString.leftAlgoFm(dateTimeF.month);
    } else {
      return formate.toYearFormateString.leftAlgoFm(dateTimeF.year);
    }
  }
}

class TimeAgoFormate {
  final String? secound;
  final String? minute;
  final String? hour;
  final String? day;
  final String? week;
  final String? month;
  final String? year;
  TimeAgoFormate({
    this.secound,
    this.minute,
    this.hour,
    this.day,
    this.week,
    this.month,
    this.year,
  });
}

extension ReplashingLeftAgo on String {
  String leftAlgoFm(int value) {
    String fmv = replaceFirst('##', value.toString());
    if (value > 1) {
      fmv = fmv.replaceFirst("'#", "s");
    } else {
      fmv = fmv.replaceFirst("'#", "");
    }
    return fmv;
  }
}

extension GetFormateStr on TimeAgoFormate? {
  String get toSecoundFormateString {
    String fm = "## secound'# ago";
    if (this != null) {
      if (this?.secound != null) {
        fm = this?.secound ?? fm;
      }
    }
    return fm;
  }

  String get toMinuteFormateString {
    String fm = "## minute'# ago";
    if (this != null) {
      if (this?.minute != null) {
        fm = this?.minute ?? fm;
      }
    }
    return fm;
  }

  String get toHourFormateString {
    String fm = "## hour'# ago";
    if (this != null) {
      if (this?.hour != null) {
        fm = this?.hour ?? fm;
      }
    }
    return fm;
  }

  String get toDayFormateString {
    String fm = "## day'# ago";
    if (this != null) {
      if (this?.day != null) {
        fm = this?.day ?? fm;
      }
    }
    return fm;
  }

  String get toWeekFormateString {
    String fm = "## week'# ago";
    if (this != null) {
      if (this?.week != null) {
        fm = this?.week ?? fm;
      }
    }
    return fm;
  }

  String get toMonthFormateString {
    String fm = "## month'# ago";
    if (this != null) {
      if (this?.month != null) {
        fm = this?.month ?? fm;
      }
    }
    return fm;
  }

  String get toYearFormateString {
    String fm = "## year'# ago";
    if (this != null) {
      if (this?.year != null) {
        fm = this?.year ?? fm;
      }
    }
    return fm;
  }
}

DateTimeF getTimeAgoConvertedDateTimeF(DateTime dateTime) {
  final Duration difference = DateTime.now().difference(dateTime);

  /// --for day
  int days = difference.inDays;

  /// --for year
  int years = 0;
  if (days >= 365) {
    years = (days / 365).floor();
    days = days - (years * 365);
  }

  /// --for month
  int months = 0;
  if (days >= 30) {
    months = (days / 30).floor();
    days = days - (months * 30);
  }

  /// --for week
  int weeks = 0;
  if (days >= 7) {
    weeks = (days / 7).floor();
    days = days - (weeks * 7);
  }

  //#// TIME //#//

  /// --for secound
  int secounds = 0;
  if (difference.inDays > 0) {
    var dateTimeInTimeOnly = dateTime.add(Duration(days: difference.inDays));
    final Duration tempDuration = DateTime.now().difference(dateTimeInTimeOnly);
    secounds = tempDuration.inSeconds;
  } else {
    secounds = difference.inSeconds;
  }

  /// --for hour
  int hours = 0;
  if (secounds >= 3600) {
    hours = (secounds ~/ 3600);
    secounds = secounds - (hours * 3600);
  }

  /// --for hour
  int minutes = 0;
  if (secounds >= 60) {
    minutes = secounds ~/ 60;
    secounds = secounds - (minutes * 60);
  }

  return DateTimeF(years, months, weeks, days, hours, minutes, secounds);
}
