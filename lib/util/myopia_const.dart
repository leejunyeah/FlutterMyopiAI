
import 'package:flutter/material.dart';
import 'package:flutter_myopia_ai/data/activity_item.dart';
import 'package:flutter_myopia_ai/generated/i18n.dart';
import 'package:flutter_svg/flutter_svg.dart';

const Color COLOR_MAIN_GREEN = Color(0xFF13D077);
const Color COLOR_RESULT_TITLE = Color(0xFF191919);
const Color COLOR_RESULT_HEADER = Color(0x7F191919);
const Color COLOR_RESULT_DETAIL = Color(0xFF191919);
//const Color COLOR_COMPUTER = Color(0xFF21C8D4);
//const Color COLOR_TV = Color(0xFF4F7CEC);
//const Color COLOR_PHONE = Color(0xFFF26B82);
//const Color COLOR_OTHER = Color(0xFFFD9719);
const Color COLOR_NONE = Color(0xFFEBEBEB);

const Color INDOOR_COLOR_1 = Color(0xFF64CF39);
const Color INDOOR_COLOR_2 = Color(0xFF13D077);
const Color INDOOR_COLOR_3 = Color(0xFF21C8D4);
const Color INDOOR_COLOR_4 = Color(0xFF4F7CEC);
const Color INDOOR_COLOR_5 = Color(0xFFF26B82);
const Color INDOOR_COLOR_6 = Color(0xFFFD9719);

const Color OUTDOOR_COLOR_1 = Color(0xFFFD9719);
const Color OUTDOOR_COLOR_2 = Color(0xFFF26B82);
const Color OUTDOOR_COLOR_3 = Color(0xFF9553F3);
const Color OUTDOOR_COLOR_4 = Color(0xFF21C8D4);
const Color OUTDOOR_COLOR_5 = Color(0xFF13D077);
const Color OUTDOOR_COLOR_6 = Color(0xFF64CF39);

const Color RECORDING_DIALOG_BUTTON = Color(0xFF13D077);

const INDOOR_COLORS = [
  INDOOR_COLOR_1,
  INDOOR_COLOR_2,
  INDOOR_COLOR_3,
  INDOOR_COLOR_4,
  INDOOR_COLOR_5,
  INDOOR_COLOR_6
];

const OUTDOOR_COLORS = [
  OUTDOOR_COLOR_1,
  OUTDOOR_COLOR_2,
  OUTDOOR_COLOR_3,
  OUTDOOR_COLOR_4,
  OUTDOOR_COLOR_5,
  OUTDOOR_COLOR_6
];

const String READING = 'Reading';
const String COMPUTER = 'Computer';
const String TV = 'Watching TV';
const String PHONE = 'Phone';
const String OTHER = 'Other';

const int MAX_DETAIL_COUNT = 5;

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

final Widget icBike = new SvgPicture.asset(
  'assets/ic_bike.svg',
);

final Widget icHike = new SvgPicture.asset(
  'assets/ic_hike.svg',
);

final Widget icGame = new SvgPicture.asset(
  'assets/ic_game.svg',
);

final Widget icRun = new SvgPicture.asset(
  'assets/ic_run.svg',
);

final Widget icSports = new SvgPicture.asset(
  'assets/ic_sports.svg',
);

final Widget icSwim = new SvgPicture.asset(
  'assets/ic_swim.svg',
);

final Widget icOthersOutdoor = new SvgPicture.asset(
  'assets/ic_others_outdoor.svg',
);

final Widget icApp = new SvgPicture.asset(
  'assets/app_icon.svg',
);
final Widget icLogo = new SvgPicture.asset(
  'assets/ic_logo.svg',
);

final Widget bgReading = new SvgPicture.asset(
  'assets/background_reading.svg',
);
final Widget bgComputer = new SvgPicture.asset(
  'assets/background_computer.svg',
);
final Widget bgGame = new SvgPicture.asset(
  'assets/background_game.svg',
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
final Widget bgSwim = new SvgPicture.asset(
  'assets/background_swim.svg',
);
final Widget bgSports = new SvgPicture.asset(
  'assets/background_sports.svg',
);
final Widget bgRun = new SvgPicture.asset(
  'assets/background_run.svg',
);
final Widget bgBike = new SvgPicture.asset(
  'assets/background_bike.svg',
);
final Widget bgHike = new SvgPicture.asset(
  'assets/background_hike.svg',
);
final Widget bgOthersOutdoor = new SvgPicture.asset(
  'assets/background_others_outdoor.svg',
);

final Widget eyeFace1 = new SvgPicture.asset(
  'assets/eye_exercise_face_1.svg',
);
final Widget eyeFace2 = new SvgPicture.asset(
  'assets/eye_exercise_face_2.svg',
);
final Widget eyeExercise1 = new SvgPicture.asset(
  'assets/eye_exercise_1.svg',
  height: 330,
);
final Widget eyeExercise2 = new SvgPicture.asset(
  'assets/eye_exercise_2.svg',
  height: 330,
);
final Widget eyeExercise3 = new SvgPicture.asset(
  'assets/eye_exercise_3.svg',
  height: 330,
);
final Widget eyeExercise4 = new SvgPicture.asset(
  'assets/eye_exercise_4.svg',
  height: 330,
);

Color getActivityColor(int type, {int index = -1}) {
  if (type == ActivityItem.TYPE_INDOOR) {
    return INDOOR_COLOR_2;
  }
  if (type == ActivityItem.TYPE_OUTDOOR) {
    return OUTDOOR_COLOR_2;
  }
  if (type & ActivityItem.TYPE_INDOOR != 0) {
    if (index >= 0 && index < INDOOR_COLORS.length) {
      return INDOOR_COLORS[index];
    }
    return INDOOR_COLOR_6;
  } else {
    if (index >= 0 && index < OUTDOOR_COLORS.length) {
      return OUTDOOR_COLORS[index];
    }
    return OUTDOOR_COLOR_6;
  }
}

Widget getActivityIcon(int type) {
  if (type & ActivityItem.TYPE_INDOOR != 0) {
    if (type & ActivityItem.TYPE_READING != 0) {
      return icReading;
    } else if (type & ActivityItem.TYPE_COMPUTER != 0) {
      return icComputer;
    } else if (type & ActivityItem.TYPE_TV != 0) {
      return icTv;
    } else if (type & ActivityItem.TYPE_PHONE != 0) {
      return icPhone;
    } else if (type & ActivityItem.TYPE_GAMES != 0) {
      return icGame;
    } else {
      return icOthers;
    }
  } else {
    if (type & ActivityItem.TYPE_SPORTS != 0) {
      return icSports;
    } else if (type & ActivityItem.TYPE_RUN != 0) {
      return icRun;
    } else if (type & ActivityItem.TYPE_HIKE != 0) {
      return icHike;
    } else if (type & ActivityItem.TYPE_BIKE != 0) {
      return icBike;
    } else if (type & ActivityItem.TYPE_SWIM != 0) {
      return icSwim;
    } else {
      return icOthersOutdoor;
    }
  }
}

Widget getBackground(int type) {
  if (type & ActivityItem.TYPE_INDOOR != 0) {
    if (type & ActivityItem.TYPE_READING != 0) {
      return bgReading;
    } else if (type & ActivityItem.TYPE_COMPUTER != 0) {
      return bgComputer;
    } else if (type & ActivityItem.TYPE_TV != 0) {
      return bgTv;
    } else if (type & ActivityItem.TYPE_PHONE != 0) {
      return bgPhone;
    } else if (type & ActivityItem.TYPE_GAMES != 0) {
      return bgGame;
    } else {
      return bgOthers;
    }
  } else {
    if (type & ActivityItem.TYPE_SPORTS != 0) {
      return bgSports;
    } else if (type & ActivityItem.TYPE_HIKE != 0) {
      return bgHike;
    } else if (type & ActivityItem.TYPE_BIKE != 0) {
      return bgBike;
    } else if (type & ActivityItem.TYPE_RUN != 0) {
      return bgRun;
    } else if (type & ActivityItem.TYPE_SWIM != 0) {
      return bgSwim;
    } else {
      return bgOthersOutdoor;
    }
  }
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
  } else if (type & ActivityItem.TYPE_GAMES != 0) {
    return S.of(context).activity_playing_games;
  } else if (type & ActivityItem.TYPE_SPORTS != 0) {
    return S.of(context).activity_sports;
  } else if (type & ActivityItem.TYPE_HIKE != 0) {
    return S.of(context).activity_hike;
  } else if (type & ActivityItem.TYPE_SWIM != 0) {
    return S.of(context).activity_swim;
  } else if (type & ActivityItem.TYPE_BIKE != 0) {
    return S.of(context).activity_bike;
  } else if (type & ActivityItem.TYPE_RUN != 0) {
    return S.of(context).activity_run;
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
  } else if (type & ActivityItem.TYPE_GAMES != 0) {
    return S.of(context).activity_games;
  } else if (type & ActivityItem.TYPE_SPORTS != 0) {
    return S.of(context).activity_sports;
  } else if (type & ActivityItem.TYPE_HIKE != 0) {
    return S.of(context).activity_hike;
  } else if (type & ActivityItem.TYPE_SWIM != 0) {
    return S.of(context).activity_swim;
  } else if (type & ActivityItem.TYPE_BIKE != 0) {
    return S.of(context).activity_bike;
  } else if (type & ActivityItem.TYPE_RUN != 0) {
    return S.of(context).activity_run;
  } else {
    return S.of(context).activity_customise;
  }
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
