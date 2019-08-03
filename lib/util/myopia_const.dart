import 'package:flutter/material.dart';
import 'package:flutter_myopia_ai/data/activity_item.dart';
import 'package:flutter_myopia_ai/generated/i18n.dart';
import 'package:flutter_svg/flutter_svg.dart';

const Color COLOR_MAIN_GREEN = Color(0xFF13D077);
const Color COLOR_RESULT_TITLE = Color(0xFF191919);
const Color COLOR_RESULT_HEADER = Color(0x7F191919);
const Color COLOR_RESULT_DETAIL = Color(0xFF191919);
const Color COLOR_COMPUTER = Color(0xFF21C8D4);
const Color COLOR_TV = Color(0xFF4F7CEC);
const Color COLOR_PHONE = Color(0xFFF26B82);
const Color COLOR_OTHER = Color(0xFFFD9719);
const Color COLOR_NONE = Color(0xFFEBEBEB);

const String READING = 'Reading';
const String COMPUTER = 'Computer';
const String TV = 'Watching TV';
const String PHONE = 'Phone';
const String OTHER = 'Other';

const TextStyle STYLE_RESULT_HEADER = TextStyle(
  color: COLOR_RESULT_HEADER,
  fontSize: 14,
);
const TextStyle STYLE_RESULT_DETAIL = TextStyle(
  fontWeight: FontWeight.bold,
  color: COLOR_RESULT_DETAIL,
  fontSize: 14,
);

const TextStyle STYLE_EDIT_ITEM = TextStyle(
  fontWeight: FontWeight.bold,
  color: Color(0xDD000000),
  fontSize: 20,
);

const ShapeBorder CARD_SHAPE = const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(12.0)));

final Widget icGlasses = new SvgPicture.asset(
  'assets/ic_glasses.svg',
);
final Widget icActivity = new SvgPicture.asset(
  'assets/ic_activity.svg',
);
final Widget icStartActivity = new SvgPicture.asset(
  'assets/img_start_a_new_activity.svg',
);

final Widget icEyeExercise = new SvgPicture.asset(
  'assets/img_eye_exercise.svg',
);

final Widget icAssignment = new SvgPicture.asset(
  'assets/ic_assignment.svg',
);

final Widget icSearchMyLevel = new SvgPicture.asset(
  'assets/ic_search_myopia_level.svg',
);

final Widget icStatistic = new SvgPicture.asset(
  'assets/ic_statistic.svg',
);

final Widget ic202020 = new SvgPicture.asset(
  'assets/ic_20_20_20.svg',
);

final Widget icFeedback = new SvgPicture.asset(
  'assets/ic_feedback.svg',
);

final Widget icAboutUs = new SvgPicture.asset(
  'assets/ic_about_us.svg',
);

final Widget icRateUs = new SvgPicture.asset(
  'assets/ic_rate_us.svg',
);

final Widget icReading = new SvgPicture.asset(
  'assets/ic_reading.svg',
);

final Widget icComputer = new SvgPicture.asset(
  'assets/ic_computer.svg',
);

final Widget icTv = new SvgPicture.asset(
  'assets/ic_watching_tv.svg',
);

final Widget icPhone = new SvgPicture.asset(
  'assets/ic_phone.svg',
);

final Widget icOthers = new SvgPicture.asset(
  'assets/ic_others.svg',
);

final Widget icApp = new SvgPicture.asset(
  'assets/app_icon.svg',
);

final Widget bgReading = new SvgPicture.asset(
  'assets/background_reading.svg',
);
final Widget bgComputer = new SvgPicture.asset(
  'assets/background_computer.svg',
);
final Widget bgPhone = new SvgPicture.asset(
  'assets/background_phone.svg',
);
final Widget bgTv = new SvgPicture.asset(
  'assets/background_watching_tv.svg',
);
final Widget bgOthers = new SvgPicture.asset(
  'assets/background_others.svg',
);

final Widget eyeExercise1 = new SvgPicture.asset(
  'assets/eye_exercise_1.svg',
);
final Widget eyeExercise2 = new SvgPicture.asset(
  'assets/eye_exercise_2.svg',
);
final Widget eyeExercise3 = new SvgPicture.asset(
  'assets/eye_exercise_3.svg',
);
final Widget eyeExercise4 = new SvgPicture.asset(
  'assets/eye_exercise_4.svg',
);

Color getColor(String item) {
  if (item == READING) {
    return COLOR_MAIN_GREEN;
  }
  if (item == COMPUTER) {
    return COLOR_COMPUTER;
  }
  if (item == TV) {
    return COLOR_TV;
  }
  if (item == PHONE) {
    return COLOR_PHONE;
  }
  if (item == OTHER) {
    return COLOR_OTHER;
  }
  return COLOR_NONE;
}

Color getActivityColor(int type) {
  if (type & ActivityItem.TYPE_READING != 0 ||
      type & ActivityItem.TYPE_SPORTS != 0) {
    return COLOR_MAIN_GREEN;
  } else if (type & ActivityItem.TYPE_COMPUTER != 0 ||
      type & ActivityItem.TYPE_HIKE != 0) {
    return COLOR_COMPUTER;
  } else if (type & ActivityItem.TYPE_TV != 0 ||
      type & ActivityItem.TYPE_SWIM != 0) {
    return COLOR_TV;
  } else if (type & ActivityItem.TYPE_PHONE != 0) {
    return COLOR_PHONE;
  } else if (type & ActivityItem.TYPE_INDOOR != 0) {
    ///TODO,junye.li
    return COLOR_PHONE;
  } else if (type & ActivityItem.TYPE_OUTDOOR != 0) {
    ///TODO,junye.li
    return COLOR_OTHER;
  } else {
    return COLOR_OTHER;
  }
}

Widget getIcon(String item) {
  if (item == READING) {
    return icReading;
  }
  if (item == COMPUTER) {
    return icComputer;
  }
  if (item == TV) {
    return icTv;
  }
  if (item == PHONE) {
    return icPhone;
  }
  if (item == OTHER) {
    return icOthers;
  }
  return icOthers;
}

Widget getBackground(int type) {
  if (type & ActivityItem.TYPE_READING != 0) {
    return bgReading;
  } else if (type & ActivityItem.TYPE_COMPUTER != 0) {
    return bgComputer;
  } else if (type & ActivityItem.TYPE_TV != 0) {
    return bgTv;
  } else if (type & ActivityItem.TYPE_PHONE != 0) {
    return bgPhone;
  } else {
    return bgOthers;
  }
}

String getTypeString(int item) {
  switch (item) {
    case ActivityItem.TYPE_READING:
      return READING;
    case ActivityItem.TYPE_COMPUTER:
      return COMPUTER;
    case ActivityItem.TYPE_PHONE:
      return PHONE;
    case ActivityItem.TYPE_TV:
      return TV;
    case ActivityItem.TYPE_CUSTOM:
      return OTHER;
  }
  return OTHER;
}

String getActivityTypeString(BuildContext context, int type) {
  if (type & ActivityItem.TYPE_READING != 0) {
    return S.of(context).activity_reading;
  } else if (type & ActivityItem.TYPE_COMPUTER != 0) {
    return S.of(context).activity_front_computer;
  } else if (type & ActivityItem.TYPE_TV != 0) {
    return S.of(context).activity_tv;
  } else if (type & ActivityItem.TYPE_PHONE != 0) {
    return S.of(context).activity_using_phone;
  } else if (type & ActivityItem.TYPE_SPORTS != 0) {
    return S.of(context).activity_sports;
  } else if (type & ActivityItem.TYPE_HIKE != 0) {
    return S.of(context).activity_hike;
  } else if (type & ActivityItem.TYPE_SWIM != 0) {
    return S.of(context).activity_swim;
  } else {
    return S.of(context).activity_customise;
  }
}

String getShortActivityTypeString(BuildContext context, int type) {
  if (type & ActivityItem.TYPE_READING != 0) {
    return S.of(context).activity_reading;
  } else if (type & ActivityItem.TYPE_COMPUTER != 0) {
    return S.of(context).activity_computer;
  } else if (type & ActivityItem.TYPE_TV != 0) {
    return S.of(context).activity_short_tv;
  } else if (type & ActivityItem.TYPE_PHONE != 0) {
    return S.of(context).activity_phone;
  } else if (type & ActivityItem.TYPE_SPORTS != 0) {
    return S.of(context).activity_sports;
  } else if (type & ActivityItem.TYPE_HIKE != 0) {
    return S.of(context).activity_hike;
  } else if (type & ActivityItem.TYPE_SWIM != 0) {
    return S.of(context).activity_swim;
  } else {
    return S.of(context).activity_customise;
  }
}

int getTypeInt(String item) {
  if (item == READING) {
    return ActivityItem.TYPE_READING;
  }
  if (item == COMPUTER) {
    return ActivityItem.TYPE_COMPUTER;
  }
  if (item == PHONE) {
    return ActivityItem.TYPE_PHONE;
  }
  if (item == TV) {
    return ActivityItem.TYPE_TV;
  }
  if (item == OTHER) {
    return ActivityItem.TYPE_CUSTOM;
  }
  return ActivityItem.TYPE_NONE;
}

int getMonthDayCount(DateTime time) {
  int month = time.month;
  int year = time.year;
  if (month <= 7) {
    if (month == 2) {
      if (isLeapYear(year)) {
        return 29;
      } else {
        return 28;
      }
    } else {
      if (month % 2 == 0) {
        return 30;
      } else {
        return 31;
      }
    }
  } else {
    if (month % 2 == 0) {
      return 31;
    } else {
      return 30;
    }
  }
}

bool isLeapYear(int year) {
  if (year % 400 == 0) {
    return true;
  }
  if (year % 4 == 0 && year % 100 != 0) {
    return true;
  }
  return false;
}

const int RESULT_TO_EDIT = 1001;
const int HOME_TO_RESULT = 1002;
const int HOME_TO_EDIT = 1003;
const int HOME_TO_START_ACTIVITY = 1004;
