import 'package:flutter/material.dart';
import 'package:flutter_myopia_ai/activity/start_activity.dart';
import 'package:flutter_myopia_ai/chart/activity_chart.dart';
import 'package:flutter_myopia_ai/data/SortActivityItem.dart';
import 'package:flutter_myopia_ai/data/activity_item.dart';
import 'package:flutter_myopia_ai/data/custom_type.dart';
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
  Map<int, CustomType> _customList;
  int _totalTime = 0;

  int _totalHour = 0;
  int _totalMins = 0;

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
        actions: <Widget>[
          /*
          下面是一个弹出菜单按钮，包含两个属性点击属性和弹出菜单子项的建立
          其中<String>是表示这个弹出菜单的value内容是String类型
           */
          new PopupMenuButton<String>(
              //这是点击弹出菜单的操作，点击对应菜单后，改变屏幕中间文本状态，将点击的菜单值赋予屏幕中间文本
              onSelected: (String value) {
                if (value == 'start') {
                  _handleStartAction();
                } else if (value == 'add') {
                  _handleAddAction();
                }
              },
              //这是弹出菜单的建立，包含了两个子项，分别是增加和删除以及他们对应的值
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    PopupMenuItem(
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          new Text(S.of(context).activity_menu_start),
                        ],
                      ),
                      value: 'start',
                    ),
                    PopupMenuItem(
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          new Text(S.of(context).activity_menu_add),
                        ],
                      ),
                      value: 'add',
                    )
                  ])
        ],
      ),
      body: (_totalTime <= 0)
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
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    S.of(context).activity_indoor_activity,
                    style: TextStyle(
                        fontSize: 16,
                        color: COLOR_RESULT_TITLE,
                        fontWeight: FontWeight.bold),
                  ),
                  _buildActivityCards(_dataList, ActivityItem.TYPE_INDOOR),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    S.of(context).activity_outdoor_activity,
                    style: TextStyle(
                        fontSize: 16,
                        color: COLOR_RESULT_TITLE,
                        fontWeight: FontWeight.bold),
                  ),
                  _buildActivityCards(_dataList, ActivityItem.TYPE_OUTDOOR),
                ],
              ),
            ),
    );
  }

  _handleStartAction() async {
    int result = await Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new StartActivity()),
    );
    if (result == HOME_TO_START_ACTIVITY) {
      _getActivityList();
      setState(() {});
    }
  }

  _handleAddAction() async {
    int result = await Navigator.push(
      context,
      new MaterialPageRoute(
          builder: (context) => new StartActivity(
                forStartActivity: false,
              )),
    );
    if (result == HOME_TO_START_ACTIVITY) {
      _getActivityList();
      setState(() {});
    }
  }

  Widget _buildTotalCard() {
    return InkWell(
      onTap: () {
        if (_totalTime > 0) {
          Navigator.push(
            context,
            new MaterialPageRoute(
              builder: (context) => new ActivityChartWidget(
                itemType: ActivityItem.TYPE_NONE,
              ),
            ),
          );
        }
      },
      child: Card(
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
      ),
    );
  }

  Widget _buildActivityCards(
      List<SortActivityItem> dataList, int indoorOutdoorType) {
    List<Widget> children = [];
    List<SortActivityItem> sortedList = [];
    if (dataList == null || dataList.isEmpty) {
      sortedList = null;
    } else {
      dataList.forEach((element) {
        if (element.type & indoorOutdoorType != 0) {
          sortedList.add(element);
        }
      });
    }

    if (sortedList == null || sortedList.isEmpty) {
      children.add(SizedBox(
        height: 16,
      ));
      children.add(Icon(MyIcons.ic_data_empty_state,
          size: 40, color: Color(0xFFB2B2B2)));
      children.add(SizedBox(
        height: 16,
      ));
      children.add(Text(
        //'No data today',
        S.of(context).activity_no_data,
        style: TextStyle(
          fontSize: 16,
          color: Color(0xFFB2B2B2),
        ),
      ));
      return Column(
        children: children,
      );
    }
    children.add(SizedBox(
      height: 16,
    ));
    int index = 0;
    sortedList.forEach((element) {
      if (element.type & indoorOutdoorType != 0) {
        if (index >= MAX_DETAIL_COUNT) return;
        int hour = element.totalTime ~/ (60 * 60);
        int min = (element.totalTime - (hour * 60 * 60)) ~/ 60;
        children.add(_buildActivityCard(
            element, hour.toString(), min.toString(),
            index: index));
        index++;
      }
    });

    SortActivityItem otherTotal = new SortActivityItem();
    otherTotal.type = ActivityItem.TYPE_OTHER_TOTAL | indoorOutdoorType;
    otherTotal.customType = 0;
    otherTotal.value = 0;
    otherTotal.totalTime = 0;
    for (int i = MAX_DETAIL_COUNT; i < sortedList.length; i++) {
      otherTotal.value += sortedList[i].value;
      otherTotal.totalTime += sortedList[i].totalTime;
    }
    if (otherTotal.value > 0 && otherTotal.totalTime > 0) {
      int hour = otherTotal.totalTime ~/ (60 * 60);
      int min = (otherTotal.totalTime - (hour * 60 * 60)) ~/ 60;
      children
          .add(_buildActivityCard(otherTotal, hour.toString(), min.toString()));
    }

    Widget column = Column(
      children: children,
    );
    return column;
  }

  Widget _buildActivityCard(SortActivityItem item, String hour, String min,
      {int index = -1}) {
    String itemText = getActivityTypeString(context, item.type);
    if (item.type & ActivityItem.TYPE_CUSTOM != 0) {
      if (_customList.containsKey(item.customType)) {
        itemText = _customList[item.customType].typeText;
      }
    } else if (item.type & ActivityItem.TYPE_OTHER_TOTAL != 0) {
      itemText = S.of(context).activity_others;
    }
    double value = item.value;
    Color color = getActivityColor(item.type, index: index);
    return InkWell(
      onTap: () => Navigator.push(
        context,
        new MaterialPageRoute(
          builder: (context) => new ActivityChartWidget(
            itemType: item.type,
            customType: item.customType,
            customText: itemText,
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
              Container(
                width: 42,
                height: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: getActivityIcon(item.type),
              ),
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
                      itemText,
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
                          color: color,
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
                      colors: [color, color],
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

    _customList = new Map();
    List<CustomType> customList =
        await DatabaseHelper.internal().selectCustomList();
    for (CustomType customType in customList) {
      if (!_customList.containsKey(customType)) {
        _customList[customType.id] = customType;
      }
    }

    _getActualTimeAndPercent();
  }

  _getActualTimeAndPercent() {
    _dataList = [];
    _totalTime = 0;
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
        _totalTime += item.actual;
        _dataList.add(sortActivityItem);
      } else {
        sortActivityItem.totalTime += item.actual;
        _totalTime += item.actual;
      }
    }

    // Sort the list by descending
    _dataList.sort((left, right) => right.totalTime.compareTo(left.totalTime));
    _totalHour = _totalTime ~/ (60 * 60);
    _totalMins = (_totalTime - _totalHour * 60 * 60) ~/ 60;

    for (SortActivityItem item in _dataList) {
      item.value = (item.totalTime * 100) / _totalTime;
    }

    if (mounted) {
      setState(() {});
    }
  }
}
