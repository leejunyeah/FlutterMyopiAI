import 'package:flutter/material.dart';
import 'package:flutter_myopia_ai/data/SortActivityItem.dart';
import 'package:flutter_myopia_ai/data/activity_item.dart';
import 'package:flutter_myopia_ai/data/custom_type.dart';
import 'package:flutter_myopia_ai/data/database_helper.dart';

import 'package:flutter_myopia_ai/data/gl_data.dart';
import 'package:flutter_myopia_ai/exercise/start_eye_exercise.dart';
import 'package:flutter_myopia_ai/home/edit_myopia.dart';
import 'package:flutter_myopia_ai/home/home_total_progress.dart';
import 'package:flutter_myopia_ai/home/result_myopia.dart';
import 'package:flutter_myopia_ai/util/myopia_const.dart';
import 'package:flutter_myopia_ai/activity/start_activity.dart';

import '../generated/i18n.dart';

class Home extends StatefulWidget {

  final TabController tabController;

  Home({this.tabController});

  @override
  HomeState createState() => new HomeState();
}

class HomeState extends State<Home> {
  String _myopiaResult = '';
  String _tips = '';

  int _totalHour = 0;
  int _totalMin = 0;

  List<ActivityItem> _activityList;
  List<SortActivityItem> _dataList;
  List<Color> _indoorColorList;
  List<Color> _outdoorColorList;
  Map<int, CustomType> _customList;

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
                    dataList: _dataList,
                    indoorColorList: _indoorColorList,
                    outdoorColorList: _outdoorColorList,
                    customList: _customList,
                  ),
                ],
              ),
              onPressed: () {
                if (widget.tabController != null) {
                  widget.tabController.animateTo(1);
                }
              }
//            () => Navigator.push(
//                context,
//                new MaterialPageRoute(
//                    builder: (context) => new ActivityChartWidget(
//                          itemType: ActivityItem.TYPE_NONE,
//                        )),
//              ),
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
          Container(
            padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 16),
            alignment: Alignment.center,
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
                            builder: (context) => new StartEyeExercise()),
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
    _activityList = [];
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

    _customList = new Map();
    List<CustomType> customList =
        await DatabaseHelper.internal().selectCustomList();
    for (CustomType customType in customList) {
      if (!_customList.containsKey(customType)) {
        _customList[customType.id] = customType;
      }
    }

    int total = 0;
    _dataList = [];
    for (ActivityItem item in _activityList) {
      if (item.actual < 60) continue;
      SortActivityItem sortActivityItem = _dataList.firstWhere(
              (element) => (element.type == item.type &&
              element.customType == item.customType),
          orElse: () => null);
      if (sortActivityItem == null) {
        sortActivityItem = new SortActivityItem();
        sortActivityItem.type = item.type;
        sortActivityItem.customType = item.customType;
        sortActivityItem.totalTime = item.actual;
        total += item.actual;
        _dataList.add(sortActivityItem);
      } else {
        total += item.actual;
        sortActivityItem.totalTime += item.actual;
      }
    }
    _dataList
        .sort((left, right) => right.totalTime.compareTo(left.totalTime));

    _indoorColorList = [];
    _outdoorColorList = [];
    int indoorIndex = 0;
    int outdoorIndex = 0;
    _dataList.forEach((element) {
      if (element.type & ActivityItem.TYPE_INDOOR != 0) {
        if (indoorIndex <= MAX_DETAIL_COUNT) {
          _indoorColorList.add(
              getActivityColor(element.type, index: indoorIndex));
          indoorIndex++;
        }
      } else {
        if (outdoorIndex <= MAX_DETAIL_COUNT) {
          _outdoorColorList.add(
              getActivityColor(element.type, index: outdoorIndex));
          outdoorIndex++;
        }
      }
    });

    _totalHour = total ~/ (60 * 60);
    _totalMin = (total - _totalHour * 60 * 60) ~/ 60;

    if (mounted) {
      setState(() {});
    }
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
      _myopiaResult = S.of(context).result_setup;
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
