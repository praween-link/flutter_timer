import '../models/time_formate_model.dart';

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

/// --TIME LEFT
extension GetFormateTimeLeftStr on TimeLeftFormate? {
  String get tosecondFormateString {
    String fm = "## second'# left";
    if (this != null) {
      if (this?.second != null) {
        fm = this?.second ?? fm;
      }
    }
    return fm;
  }

  String get toMinuteFormateString {
    String fm = "## minute'# left";
    if (this != null) {
      if (this?.minute != null) {
        fm = this?.minute ?? fm;
      }
    }
    return fm;
  }

  String get toHourFormateString {
    String fm = "## hour'# left";
    if (this != null) {
      if (this?.hour != null) {
        fm = this?.hour ?? fm;
      }
    }
    return fm;
  }

  String get toDayFormateString {
    String fm = "## day'# left";
    if (this != null) {
      if (this?.day != null) {
        fm = this?.day ?? fm;
      }
    }
    return fm;
  }

  String get toWeekFormateString {
    String fm = "## week'# left";
    if (this != null) {
      if (this?.week != null) {
        fm = this?.week ?? fm;
      }
    }
    return fm;
  }

  String get toMonthFormateString {
    String fm = "## month'# left";
    if (this != null) {
      if (this?.month != null) {
        fm = this?.month ?? fm;
      }
    }
    return fm;
  }

  String get toYearFormateString {
    String fm = "## year'# left";
    if (this != null) {
      if (this?.year != null) {
        fm = this?.year ?? fm;
      }
    }
    return fm;
  }
}

/// --TIME AGO
extension GetFormateTimeAgoStr on TimeAgoFormate? {
  String get tosecondFormateString {
    String fm = "## second'# ago";
    if (this != null) {
      if (this?.second != null) {
        fm = this?.second ?? fm;
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
