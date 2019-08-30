import 'package:flutter/material.dart';
import 'package:flutter_myopia_ai/data/activity_item.dart';
import 'package:flutter_myopia_ai/generated/i18n.dart';
import 'package:flutter_svg/flutter_svg.dart';

const Color COLOR_MAIN_GREEN = Color(0xFF13D077);
const Color COLOR_RESULT_TITLE = Color(0xFF191919);
const Color COLOR_RESULT_HEADER = Color(0x7F191919);
const Color COLOR_RESULT_DETAIL = Color(0xFF191919);
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
      return SvgPicture.asset(
        'assets/ic_reading.svg',
      );
    } else if (type & ActivityItem.TYPE_COMPUTER != 0) {
      return SvgPicture.asset(
        'assets/ic_computer.svg',
      );
    } else if (type & ActivityItem.TYPE_TV != 0) {
      return SvgPicture.asset(
        'assets/ic_watching_tv.svg',
      );
    } else if (type & ActivityItem.TYPE_PHONE != 0) {
      return SvgPicture.asset(
        'assets/ic_phone.svg',
      );
    } else if (type & ActivityItem.TYPE_GAMES != 0) {
      return SvgPicture.asset(
        'assets/ic_game.svg',
      );
    } else {
      return SvgPicture.asset(
        'assets/ic_others.svg',
      );
    }
  } else {
    if (type & ActivityItem.TYPE_SPORTS != 0) {
      return SvgPicture.asset(
        'assets/ic_sports.svg',
      );
    } else if (type & ActivityItem.TYPE_RUN != 0) {
      return SvgPicture.asset(
        'assets/ic_run.svg',
      );
    } else if (type & ActivityItem.TYPE_HIKE != 0) {
      return SvgPicture.asset(
        'assets/ic_hike.svg',
      );
    } else if (type & ActivityItem.TYPE_BIKE != 0) {
      return SvgPicture.asset(
        'assets/ic_bike.svg',
      );
    } else if (type & ActivityItem.TYPE_SWIM != 0) {
      return SvgPicture.asset(
        'assets/ic_swim.svg',
      );
    } else {
      return SvgPicture.asset(
        'assets/ic_others_outdoor.svg',
      );
    }
  }
}

Widget getBackground(int type) {
  if (type & ActivityItem.TYPE_INDOOR != 0) {
    if (type & ActivityItem.TYPE_READING != 0) {
      return SvgPicture.asset(
        'assets/background_reading.svg',
      );
    } else if (type & ActivityItem.TYPE_COMPUTER != 0) {
      return SvgPicture.asset(
        'assets/background_computer.svg',
      );
    } else if (type & ActivityItem.TYPE_TV != 0) {
      return SvgPicture.asset(
        'assets/background_watching_tv.svg',
      );
    } else if (type & ActivityItem.TYPE_PHONE != 0) {
      return SvgPicture.asset(
        'assets/background_phone.svg',
      );
    } else if (type & ActivityItem.TYPE_GAMES != 0) {
      return SvgPicture.asset(
        'assets/background_game.svg',
      );
    } else {
      return SvgPicture.asset(
        'assets/background_others.svg',
      );
    }
  } else {
    if (type & ActivityItem.TYPE_SPORTS != 0) {
      return SvgPicture.asset(
        'assets/background_sports.svg',
      );
    } else if (type & ActivityItem.TYPE_HIKE != 0) {
      return SvgPicture.asset(
        'assets/background_hike.svg',
      );
    } else if (type & ActivityItem.TYPE_BIKE != 0) {
      return SvgPicture.asset(
        'assets/background_bike.svg',
      );
    } else if (type & ActivityItem.TYPE_RUN != 0) {
      return SvgPicture.asset(
        'assets/background_run.svg',
      );
    } else if (type & ActivityItem.TYPE_SWIM != 0) {
      return SvgPicture.asset(
        'assets/background_swim.svg',
      );
    } else {
      return SvgPicture.asset(
        'assets/background_others_outdoor.svg',
      );
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