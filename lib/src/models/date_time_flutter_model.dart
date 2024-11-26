class DateTimeF {
  int year = 1;
  int month = 0;
  int week = 0;
  int day = 0;
  int hour = 0;
  int minute = 0;
  int second = 0;

  DateTimeF(int vYear,
      [int vMonth = 1,
      int vWeek = 0,
      int vDay = 0,
      int vHour = 0,
      int vMinute = 0,
      int vsecond = 0]) {
    if (vYear >= 0) year = vYear;
    if (vMonth >= 0) month = vMonth;
    if (vWeek >= 0) week = vWeek;
    if (vDay >= 0) day = vDay;
    if (vHour >= 0) hour = vHour;
    if (vMinute >= 0) minute = vMinute;
    if (vsecond >= 0) second = vsecond;
  }

  @override
  String toString() {
    return "DateTimeF(year: $year, month: $month, week: $week, day: $day, hour: $hour, minute: $minute, second: $second)";
  }
}
