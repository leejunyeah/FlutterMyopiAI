import 'package:flutter/material.dart';
import 'package:flutter_myopia_ai/chart/activity_chart.dart';
import 'package:flutter_myopia_ai/data/SortActivityItem.dart';
import 'package:flutter_myopia_ai/data/activity_item.dart';
import 'package:flutter_myopia_ai/data/database_helper.dart';
import 'package:flutter_myopia_ai/fonts/my_flutter_app_icons.dart';
import 'package:flutter_myopia_ai/util/myopia_const.dart';
import 'package:flutter_myopia_ai/activity/circle_progress.dart';

import '../generated/i18n.dart';

class Activity extends StatefulWidget {
  @override
  ActivityState createState() => new ActivityState();
}

class ActivityState extends State<Activity> {
  List<ActivityItem> _activityList;
  List<SortActivityItem> _dataList;
  int _readingTime = 0;
  int _computerTime = 0;
  int _tvTime = 0;
  int _phoneTime = 0;
  int _otherTime = 0;
  int _sportsTime = 0;
  int _hikeTime = 0;
  int _swimTime = 0;

  double _reading = 0.0;
  double _computer = 0.0;
  double _tv = 0.0;
  double _phone = 0.0;
  double _other = 0.0;
  double _sports = 0.0;
  double _hike = 0.0;
  double _swim = 0.0;

  int _totalHour = 0;
  int _totalMins = 0;

  int _readingHour = 0;
  int _readingMin = 0;
  int _computerHounr = 0;
  int _computerMin = 0;
  int _tvHour = 0;
  int _tvMin = 0;
  int _phoneHour = 0;
  int _phoneMin = 0;
  int _otherHour = 0;
  int _otherMin = 0;
  int _sportHour = 0;
  int _sportMin = 0;
  int _hikeHour = 0;
  int _hikeMin = 0;
  int _swimHour = 0;
  int _swimMin = 0;

  @override
  void initState() {
    _getActivityList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text(S.of(context).activity_title),
        backgroundColor: COLOR_MAIN_GREEN,
      ),
      body: (_totalHour <= 0.0 && _totalMins <= 0)
          ? Container(
              padding: EdgeInsets.only(left: 16, top: 16, right: 16),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buildTotalCard(),
                    Expanded(
                      flex: 1,
                      child: Container(),
                    ),
                    Icon(MyIcons.ic_data_empty_state,
                        size: 80, color: Color(0xFFB2B2B2)),
                    SizedBox(
                      height: 25,
                    ),
                    Text(
                      //'No data today',
                      S.of(context).activity_no_data,
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFFB2B2B2),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(),
                    ),
                  ],
                ),
              ),
            )
          : Container(
              padding: EdgeInsets.only(left: 16, top: 16, right: 16),
              child: ListView(
                children: <Widget>[
                  _buildTotalCard(),
                  Offstage(
                    offstage: _reading <= 0.0,
                    child: _buildActivityCard(
                        READING, '$_readingHour', '$_readingMin', _reading),
                  ),
                  Offstage(
                    offstage: _computer <= 0.0,
                    child: _buildActivityCard(COMPUTER, '$_computerHounr',
                        '$_computerMin', _computer),
                  ),
                  Offstage(
                    offstage: _tv <= 0.0,
                    child: _buildActivityCard(TV, '$_tvHour', '$_tvMin', _tv),
                  ),
                  Offstage(
                    offstage: _phone <= 0.0,
                    child: _buildActivityCard(
                        PHONE, '$_phoneHour', '$_phoneMin', _phone),
                  ),
                  Offstage(
                    offstage: _other <= 0.0,
                    child: _buildActivityCard(
                        OTHER, '$_otherHour', '$_otherMin', _other),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildTotalCard() {
    return Card(
      elevation: 4,
      shape: CARD_SHAPE,
      child: Container(
        height: 57,
        padding: EdgeInsets.all(16),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              MyIcons.ic_pie_chart,
              color: COLOR_MAIN_GREEN,
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
              flex: 1,
              child: Text(
                //'Total',
                S.of(context).activity_total,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: COLOR_RESULT_TITLE,
                ),
              ),
            ),
            _buildTimeWidget('$_totalHour', '$_totalMins'),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityCard(
      String item, String hour, String min, double value) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        new MaterialPageRoute(
          builder: (context) => new ActivityChartWidget(
            itemType: getTypeInt(item),
          ),
        ),
      ),
      child: Card(
        elevation: 4,
        shape: CARD_SHAPE,
        child: Container(
          height: 98,
          padding: EdgeInsets.all(16),
          child: Row(
            children: <Widget>[
              getIcon(item),
              SizedBox(
                width: 8,
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '$item',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 12,
                          color: Color(0x33191919),
                          fontWeight: FontWeight.bold),
                    ),
                    _buildTimeWidget('$hour', '$min'),
                  ],
                ),
              ),
              Container(
                width: 66.0,
                height: 66.0,
                alignment: Alignment.center,
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Text(
                        "${value.toInt()}%",
                        style: TextStyle(
                          color: getColor(item),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    GradientCircularProgressIndicator(
                      radius: 33.0,
                      stokeWidth: 8.0,
                      value: value / 100,
                      strokeCapRound: true,
                      backgroundColor: Color(0x33191919),
                      colors: [getColor(item), getColor(item)],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeWidget(String hour, String min) {
    return Row(
      children: <Widget>[
        Text(
          '$hour',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: COLOR_RESULT_TITLE,
          ),
        ),
        Text(
          //'h',
          S.of(context).time_h,
          style: TextStyle(
            fontSize: 16,
            color: Color(0x7F191919),
          ),
        ),
        Text(
          '$min',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: COLOR_RESULT_TITLE,
          ),
        ),
        Text(
          //'min',
          S.of(context).time_min,
          style: TextStyle(
            fontSize: 16,
            color: Color(0x7F191919),
          ),
        ),
      ],
    );
  }

  //int toPercent(num deg) => (deg * (100)).toInt();

  _getActivityList() async {
    List<ActivityItem> activities =
        await DatabaseHelper.internal().selectActivities();
    _activityList = new List();
    DateTime now = DateTime.now();
    for (ActivityItem item in activities) {
      int timeInt = item.time;
      DateTime time = DateTime.fromMillisecondsSinceEpoch(timeInt);
      if (now.year == time.year &&
          now.month == time.month &&
          now.day == time.day) {
        _activityList.add(item);
      }
    }
    _getActualTimeAndPercent();
  }

  _getActualTimeAndPercent() {
    _readingTime = 0;
    _computerTime = 0;
    _tvTime = 0;
    _phoneTime = 0;
    _otherTime = 0;
    _sportsTime = 0;
    _swimTime = 0;
    _hikeTime = 0;

    _reading = 0.0;
    _computer = 0.0;
    _tv = 0.0;
     _phone = 0.0;
    _other = 0.0;
    _sports = 0.0;
    _swim = 0.0;
    _hike = 0.0;


    _dataList = [];
    for (ActivityItem item in _activityList) {
      SortActivityItem sortActivityItem = _dataList.firstWhere((element) => (element.type == item.type));
      if (sortActivityItem == null) {
        sortActivityItem = new SortActivityItem();
        sortActivityItem.type = item.type;
        sortActivityItem.totalTime = ((item.actual ~/ 60) * 60);
        _dataList.add(sortActivityItem);
      } else {
        sortActivityItem.totalTime += ((item.actual ~/ 60) * 60);
      }

      if (item.type & ActivityItem.TYPE_READING != 0) {
        _readingTime += ((item.actual ~/ 60) * 60);
      } else if (item.type & ActivityItem.TYPE_TV != 0) {
        _tvTime += ((item.actual ~/ 60) * 60);
      } else if (item.type & ActivityItem.TYPE_COMPUTER != 0) {
        _computerTime += ((item.actual ~/ 60) * 60);
      } else if (item.type & ActivityItem.TYPE_PHONE != 0) {
        _phoneTime += ((item.actual ~/ 60) * 60);
      } else if (item.type & ActivityItem.TYPE_CUSTOM != 0) {
        _otherTime += ((item.actual ~/ 60) * 60);
      } else if (item.type & ActivityItem.TYPE_SPORTS != 0) {
        _sportsTime += ((item.actual ~/ 60) * 60);
      } else if (item.type & ActivityItem.TYPE_HIKE != 0) {
        _hikeTime += ((item.actual ~/ 60) * 60);
      } else if (item.type & ActivityItem.TYPE_SWIM != 0) {
        _swimTime += ((item.actual ~/ 60) * 60);
      }
    }

    // Sort the list by descending
    _dataList.sort((left, right) => right.totalTime.compareTo(left.totalTime));

    _readingTime = _readingTime < 60 ? 0 : _readingTime;
    _tvTime = _tvTime < 60 ? 0 : _tvTime;
    _computerTime = _computerTime < 60 ? 0 : _computerTime;
    _phoneTime = _phoneTime < 60 ? 0 : _phoneTime;
    _otherTime = _otherTime < 60 ? 0 : _otherTime;
    _sportsTime = _sportsTime < 60 ? 0 : _otherTime;
    _hikeTime = _hikeTime < 60 ? 0 : _hikeTime;
    _swimTime = _swimTime < 60 ? 0 : _swimTime;

    int total = _readingTime +
        _tvTime +
        _computerTime +
        _phoneTime +
        _otherTime +
        _sportsTime +
        _hikeTime +
        _swimTime;

    /// Convert to minutes to calculate the percents
    int totalM = total ~/ 60;
    double r = totalM <= 0
        ? 0
        : double.parse(
            (((_readingTime ~/ 60 * 100) ~/ totalM)).toStringAsFixed(2));
    double t = totalM <= 0
        ? 0
        : double.parse((((_tvTime ~/ 60 * 100) ~/ totalM)).toStringAsFixed(2));
    double c = totalM <= 0
        ? 0
        : double.parse(
            (((_computerTime ~/ 60 * 100) ~/ totalM)).toStringAsFixed(2));
    double p = totalM <= 0
        ? 0
        : double.parse(
            (((_phoneTime ~/ 60 * 100) ~/ totalM)).toStringAsFixed(2));
    double o = totalM <= 0 || _otherTime <= 0 ? 0 : 100 - r - t - c - p;

    double left = 100 - r - t - c - p - o;
    if (left > 0) {
      if (_otherTime > _phoneTime &&
          _otherTime > _computerTime &&
          _otherTime > _tvTime &&
          _otherTime > _readingTime &&
          o != 0) {
        o += left;
      } else if (_phoneTime > _otherTime &&
          _phoneTime > _computerTime &&
          _phoneTime > _tvTime &&
          _phoneTime > _readingTime &&
          p != 0) {
        p += left;
      } else if (_computerTime > _phoneTime &&
          _computerTime > _otherTime &&
          _computerTime > _tvTime &&
          _computerTime > _readingTime &&
          c != 0) {
        c += left;
      } else if (_tvTime > _phoneTime &&
          _tvTime > _otherTime &&
          _tvTime > _computerTime &&
          _tvTime > _readingTime &&
          t != 0) {
        t += left;
      } else if (_readingTime > _phoneTime &&
          _readingTime > _otherTime &&
          _readingTime > _computerTime &&
          _readingTime > _tv &&
          r != 0) {
        r += left;
      }
    }

    int totalHour = total ~/ (60 * 60);
    int totalMin = (total - totalHour * 60 * 60) ~/ 60;

    int rHour = _readingTime ~/ (60 * 60);
    int rMin = (_readingTime - rHour * 60 * 60) ~/ 60;

    int cHour = _computerTime ~/ (60 * 60);
    int cMin = (_computerTime - cHour * 60 * 60) ~/ 60;

    int tvHour = _tvTime ~/ (60 * 60);
    int tvMin = (_tvTime - tvHour * 60 * 60) ~/ 60;

    int pHour = _phoneTime ~/ (60 * 60);
    int pMin = (_phoneTime - pHour * 60 * 60) ~/ 60;

    int oHour = _otherTime ~/ (60 * 60);
    int oMin = (_otherTime - oHour * 60 * 60) ~/ 60;

    if (mounted) {
      setState(() {
        _totalHour = totalHour;
        _totalMins = totalMin;

        _readingHour = rHour;
        _readingMin = rMin;

        _computerHounr = cHour;
        _computerMin = cMin;

        _tvHour = tvHour;
        _tvMin = tvMin;

        _phoneHour = pHour;
        _phoneMin = pMin;

        _otherHour = oHour;
        _otherMin = oMin;

        _reading = r;
        _tv = t;
        _computer = c;
        _phone = p;
        _other = o;
      });
    }
  }
}
