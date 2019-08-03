import 'package:flutter/material.dart';
import 'package:flutter_myopia_ai/data/activity_item.dart';
import 'package:flutter_myopia_ai/data/database_helper.dart';

import 'package:flutter_myopia_ai/data/gl_data.dart';
import 'package:flutter_myopia_ai/exercise/eye_exercise.dart';
import 'package:flutter_myopia_ai/home/edit_myopia.dart';
import 'package:flutter_myopia_ai/home/home_total_progress.dart';
import 'package:flutter_myopia_ai/home/result_myopia.dart';
import 'package:flutter_myopia_ai/util/myopia_const.dart';
import 'package:flutter_myopia_ai/home/home_activity_progress.dart';
import 'package:flutter_myopia_ai/chart/activity_chart.dart';
import 'package:flutter_myopia_ai/activity/start_activity.dart';

import '../generated/i18n.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => new HomeState();
}

class HomeState extends State<Home> {
  String _myopiaResult = '';
  String _tips = '';

  int _totalHour = 0;
  int _totalMin = 0;

  List<ActivityItem> _activityList;

  @override
  void initState() {
    _getActivityList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _initResult();
    return Scaffold(
      appBar: new AppBar(
        title: new Text(S.of(context).home_title),
        backgroundColor: COLOR_MAIN_GREEN,
      ),
      body: new ListView(
        children: <Widget>[
          new Padding(
            padding: const EdgeInsets.all(16.0),
            child: new RaisedButton(
              elevation: 4,
              shape: CARD_SHAPE,
              color: Colors.white,
              padding: const EdgeInsets.only(
                  left: 20, top: 20, right: 20, bottom: 20),
              child: new Column(
                children: <Widget>[
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      new Text(
                        //'Eye Activity Time',
                        S.of(context).eye_activity_time,
                        textAlign: TextAlign.start,
                        style: new TextStyle(
                          color: COLOR_RESULT_DETAIL,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      _buildTotalHour(),
                    ],
                  ),
                  HomeTotalProgress(
                    activityList: _activityList,
                  ),
                ],
              ),
              onPressed: () => Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => new ActivityChartWidget(
                          itemType: ActivityItem.TYPE_NONE,
                        )),
              ),
            ),
          ),
          new Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 16),
            child: new RaisedButton(
              elevation: 4,
              shape: CARD_SHAPE,
              color: Colors.white,
              padding: const EdgeInsets.only(
                  left: 20, top: 20, right: 20, bottom: 20),
              child: new Column(
                children: <Widget>[
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: icGlasses,
                      ),
                      new Text(
                        _myopiaResult,
                        textAlign: TextAlign.start,
                        style: new TextStyle(
                          color: COLOR_RESULT_DETAIL,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  Container(
                    width: double.infinity,
                    alignment: Alignment.topLeft,
                    child: new Text(
                      _tips,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 4,
                      style: TextStyle(
                        color: COLOR_RESULT_HEADER,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              onPressed: () => _handleMyopia(),
            ),
          ),
          new Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 16),
            child: new Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 146,
                    padding: EdgeInsets.only(right: 5),
                    child: new RaisedButton(
                      padding: EdgeInsets.all(0),
                      elevation: 4,
                      shape: CARD_SHAPE,
                      color: Colors.transparent,
                      child: ConstrainedBox(
                        constraints: new BoxConstraints.expand(),
                        child: Stack(
                          children: <Widget>[
                            icStartActivity,
                            Container(
                              padding:
                                  EdgeInsets.only(top: 50, left: 16, right: 16),
                              alignment: Alignment.topLeft,
                              child: Text(
                                //'Start a new Activity',
                                S.of(context).start_new_activity,
                                textAlign: TextAlign.start,
                                style: new TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      onPressed: () => _gotoStartActivity(),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 146,
                    padding: EdgeInsets.only(right: 5),
                    child: new RaisedButton(
                      padding: EdgeInsets.all(0),
                      elevation: 4,
                      shape: CARD_SHAPE,
                      color: Colors.transparent,
                      child: ConstrainedBox(
                        constraints: new BoxConstraints.expand(),
                        child: Stack(
                          children: <Widget>[
                            icEyeExercise,
                            Container(
                              padding:
                                  EdgeInsets.only(top: 50, left: 16, right: 16),
                              alignment: Alignment.topLeft,
                              child: Text(
                                //'Eye exercise',
                                S.of(context).eye_exercise,
                                textAlign: TextAlign.start,
                                style: new TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new EyeExercise()),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalHour() {
    return Expanded(
      flex: 1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          new Text(
            '$_totalHour',
            textAlign: TextAlign.end,
            style: new TextStyle(
              color: COLOR_RESULT_DETAIL,
              fontSize: 24.0,
            ),
          ),
          SizedBox(
            width: 4,
          ),
          new Text(
            //"h",
            S.of(context).time_h,
            textAlign: TextAlign.end,
            style: new TextStyle(
              color: COLOR_RESULT_HEADER,
              fontSize: 16.0,
            ),
          ),
          SizedBox(
            width: 4,
          ),
          new Text(
            '$_totalMin',
            textAlign: TextAlign.end,
            style: new TextStyle(
              color: COLOR_RESULT_DETAIL,
              fontSize: 24.0,
            ),
          ),
          SizedBox(
            width: 4,
          ),
          new Text(
            //_totalMin > 1 ? 'mins' : 'min',
            _totalMin > 1 ? S.of(context).time_mins : S.of(context).time_min,
            textAlign: TextAlign.end,
            style: new TextStyle(
              color: COLOR_RESULT_HEADER,
              fontSize: 16.0,
            ),
          )
        ],
      ),
    );
  }

  String _getTips() {
    String s = '';
    if (glResult == LEVEL_MILD) {
      s = S.of(context).mild_des_diagnosis;
    } else if (glResult == LEVEL_MODERATE) {
      s = S.of(context).moderate_des_diagnosis;
    } else if (glResult == LEVEL_HIGH) {
      s = S.of(context).high_des_diagnosis;
    } else if (glResult == LEVEL_NORMAL) {
      s = S.of(context).normal_des_diagnosis;
    } else {
      s = 'Tap to setup myopia';
    }
    return s;
  }

  _getActivityList() async {
    _totalHour = 0;
    _totalMin = 0;

    List<ActivityItem> activities =
        await DatabaseHelper.internal().selectActivities();
    List<ActivityItem> tempList = new List();
    DateTime now = DateTime.now();
    for (ActivityItem item in activities) {
      int timeInt = item.time;
      DateTime time = DateTime.fromMillisecondsSinceEpoch(timeInt);
      if (now.year == time.year &&
          now.month == time.month &&
          now.day == time.day) {
        tempList.add(item);
      }
    }

    int readingTime = 0;
    int computerTime = 0;
    int tvTime = 0;
    int phoneTime = 0;
    int otherTime = 0;
    int sportsTime = 0;
    int hikeTime = 0;
    int swimTime = 0;

    for (ActivityItem item in tempList) {
      if (item.type & ActivityItem.TYPE_READING != 0) {
        readingTime += ((item.actual ~/ 60) * 60);
      } else if (item.type & ActivityItem.TYPE_TV != 0) {
        tvTime += ((item.actual ~/ 60) * 60);
      } else if (item.type & ActivityItem.TYPE_COMPUTER != 0) {
        computerTime += ((item.actual ~/ 60) * 60);
      } else if (item.type & ActivityItem.TYPE_PHONE != 0) {
        phoneTime += ((item.actual ~/ 60) * 60);
      } else if (item.type & ActivityItem.TYPE_SPORTS != 0) {
        sportsTime += ((item.actual ~/ 60) * 60);
      } else if (item.type & ActivityItem.TYPE_HIKE != 0) {
        hikeTime += ((item.actual ~/ 60) * 60);
      } else if (item.type & ActivityItem.TYPE_SWIM != 0) {
        swimTime += ((item.actual ~/ 60) * 60);
      } else if (item.type & ActivityItem.TYPE_CUSTOM != 0) {
        otherTime += ((item.actual ~/ 60) * 60);
      }
    }

    int total = readingTime +
        tvTime +
        computerTime +
        phoneTime +
        otherTime +
        sportsTime +
        sportsTime +
        hikeTime +
        swimTime;
    int hour = (total ~/ (60 * 60)).toInt();
    int min = ((total - hour * 60 * 60) ~/ 60).toInt();

    setState(() {
      _activityList = tempList;
      _totalHour = hour;
      _totalMin = min;
    });
  }

  _initResult() {
    if (glResult == LEVEL_MILD) {
      _myopiaResult = S.of(context).result_mild;
    } else if (glResult == LEVEL_MODERATE) {
      _myopiaResult = S.of(context).result_moderate;
    } else if (glResult == LEVEL_HIGH) {
      _myopiaResult = S.of(context).result_high;
    } else if (glResult == LEVEL_NORMAL) {
      _myopiaResult = S.of(context).result_normal;
    } else {
      _myopiaResult = 'Setup';
    }
    _tips = _getTips();
  }

  _handleMyopia() async {
    if (glResult == null || _getTips() == 'Tap to setup myopia') {
      int result = await Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => new EditMyopia(
                  fromHome: true,
                )),
      );
      if (result == HOME_TO_EDIT) {
//        _initResult();
        setState(() {});
      }
    } else {
      int result = await Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => new ResultMyopia(
                  fromHome: true,
                )),
      );
      if (result == HOME_TO_RESULT) {
//        _initResult();
        setState(() {});
      }
    }
  }

  _gotoStartActivity() async {
    int result = await Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new StartActivity()),
    );
    if (result == HOME_TO_START_ACTIVITY) {
      _getActivityList();
      setState(() {});
    }
  }
}
