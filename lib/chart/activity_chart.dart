import 'package:flutter/material.dart';
import 'package:flutter_myopia_ai/chart/charts_widget.dart';
import 'package:flutter_myopia_ai/data/activity_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_myopia_ai/util/myopia_const.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_myopia_ai/data/database_helper.dart';
import 'package:flutter_myopia_ai/util/date_format.dart';

import '../generated/i18n.dart' as i18n;

class ActivityChartWidget extends StatefulWidget {
  final int itemType;
  final int customType;
  final String customText;
  ActivityChartWidget(
      {Key key, this.itemType, this.customType = 0, this.customText = ''})
      : super(key: key);

  @override
  _ActivityChartWidgetState createState() => new _ActivityChartWidgetState();
}

class _ActivityChartWidgetState extends State<ActivityChartWidget> {
  bool _isDChecked = true;
  bool _isWChecked = false;
  bool _isMChecked = false;
  bool _isYChecked = false;

  bool _lastEnable = true;
  bool _nextEnable = true;

  DateTime _pickDate = DateTime.now();

  List<charts.Series<ActivityData, String>> _seriesList;
  List<charts.TickSpec<String>> _ticks;

  String _selectDay;
  String _averageHour, _averageMin;
  String _title;

  _ActivityChartWidgetState();

  @override
  void initState() {
    _isDChecked = true;
    _isWChecked = false;
    _isMChecked = false;
    _isYChecked = false;
    _pickDate = DateTime.now();
    _checkNextEnable();
    _selectDay = _getDayString(_pickDate);
    _seriesList = _createDailyEmptyData();
    _ticks = _createDailyTick();
    _createDailyDataState(_pickDate, widget.itemType, widget.customType);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _setTitle();
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: false,
        title: new Text(_title),
        bottom: _buildHeaderButtons(),
        backgroundColor: COLOR_MAIN_GREEN,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          shape: CARD_SHAPE,
          child: Container(
            padding: EdgeInsets.only(left: 24, top: 16, right: 24, bottom: 24),
            child: Column(
              children: <Widget>[
                _buildDateHeader(),
                Container(
                  alignment: Alignment.center,
                  height: 320,
                  child: ChartWidget(
                    seriesList: _seriesList,
                    ticks: _ticks,
                  ),
                ),
                SizedBox(
                  height: 26,
                ),
                _buildAverage(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAverage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            _selectDay,
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 12,
              color: COLOR_RESULT_HEADER,
            ),
          ),
        ),
        SizedBox(
          height: 4,
        ),
        Divider(
          color: Color(0xFF6FD598),
          height: 1,
        ),
        SizedBox(
          height: 8,
        ),
        Row(
          children: <Widget>[
            Text(
              //'Average',
              i18n.S.of(context).activity_chart_total,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: COLOR_RESULT_TITLE,
              ),
            ),
            Expanded(
              flex: 1,
              child: _buildTimeWidget(_averageHour, _averageMin),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTimeWidget(String hour, String min) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Text(
          '$hour',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: COLOR_RESULT_TITLE,
          ),
        ),
        Text(
          i18n.S.of(context).time_h,
          style: TextStyle(
            fontSize: 14,
            color: Color(0x7F191919),
          ),
        ),
        Text(
          '$min',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: COLOR_RESULT_TITLE,
          ),
        ),
        Text(
          i18n.S.of(context).time_min,
          style: TextStyle(
            fontSize: 14,
            color: Color(0x7F191919),
          ),
        ),
      ],
    );
  }

  Widget _buildDateHeader() {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 24,
          height: 24,
          child: FlatButton(
            padding: EdgeInsets.all(0),
            color: _lastEnable ? COLOR_MAIN_GREEN : Colors.grey,
            highlightColor: _lastEnable ? COLOR_MAIN_GREEN : Colors.grey,
            colorBrightness: Brightness.dark,
            splashColor: Colors.grey,
            child: Icon(
              Icons.chevron_left,
              color: Colors.white,
            ),
            shape: const CircleBorder(),
            onPressed: () {
              _handleLast();
            },
          ),
        ),
        Expanded(
          flex: 1,
          child: FlatButton(
            padding: EdgeInsets.all(0),
            colorBrightness: Brightness.dark,
            splashColor: Colors.grey,
            child: Text(
              _selectDay,
              style: TextStyle(
                color: COLOR_RESULT_TITLE,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            onPressed: () => _showDatePicker(),
          ),
        ),
        SizedBox(
          width: 24,
          height: 24,
          child: FlatButton(
            padding: EdgeInsets.all(0),
            color: _nextEnable ? COLOR_MAIN_GREEN : Colors.grey,
            highlightColor: _nextEnable ? COLOR_MAIN_GREEN : Colors.grey,
            colorBrightness: Brightness.dark,
            splashColor: Colors.grey,
            child: Icon(
              Icons.chevron_right,
              color: Colors.white,
            ),
            shape: const CircleBorder(),
            onPressed: () {
              _handleNext();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderButtons() {
    return PreferredSize(
      preferredSize: Size(60, 60),
      child: Padding(
        padding: EdgeInsets.only(left: 10, top: 5, right: 10, bottom: 15),
        child: Container(
          width: 304,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26.0),
            color: Color(0xFF6FD598),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 76,
                height: 36,
                child: FlatButton(
                  padding: EdgeInsets.all(0),
                  color: _isDChecked ? Colors.white : Colors.transparent,
                  highlightColor: Colors.white,
                  colorBrightness: Brightness.dark,
                  splashColor: Colors.grey,
                  child: Text(
                    "DAY",
                    style: TextStyle(
                      color: _isDChecked ? COLOR_MAIN_GREEN : Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50))),
                  onPressed: _handleDCheck,
                ),
              ),
              SizedBox(
                width: 76,
                height: 36,
                child: FlatButton(
                  padding: EdgeInsets.all(0),
                  color: _isWChecked ? Colors.white : Colors.transparent,
                  highlightColor: Colors.white,
                  colorBrightness: Brightness.dark,
                  splashColor: Colors.grey,
                  child: Text(
                    "WEEK",
                    style: TextStyle(
                      color: _isWChecked ? COLOR_MAIN_GREEN : Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50))),
                  onPressed: _handleWCheck,
                ),
              ),
              SizedBox(
                width: 76,
                height: 36,
                child: FlatButton(
                  padding: EdgeInsets.all(0),
                  color: _isMChecked ? Colors.white : Colors.transparent,
                  highlightColor: Colors.white,
                  colorBrightness: Brightness.dark,
                  splashColor: Colors.grey,
                  child: Text(
                    "MONTH",
                    style: TextStyle(
                      color: _isMChecked ? COLOR_MAIN_GREEN : Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50))),
                  onPressed: _handleMCheck,
                ),
              ),
              SizedBox(
                width: 76,
                height: 36,
                child: FlatButton(
                  padding: EdgeInsets.all(0),
                  color: _isYChecked ? Colors.white : Colors.transparent,
                  highlightColor: Colors.white,
                  colorBrightness: Brightness.dark,
                  splashColor: Colors.grey,
                  child: Text(
                    "YEAR",
                    style: TextStyle(
                      color: _isYChecked ? COLOR_MAIN_GREEN : Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50))),
                  onPressed: _handleYCheck,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleDCheck() {
    if (!_isDChecked) {
      _isDChecked = true;
      _isWChecked = false;
      _isMChecked = false;
      _isYChecked = false;

      _ticks = _createDailyTick();
      _selectDay = _getDayString(_pickDate);
      _createDailyDataState(_pickDate, widget.itemType, widget.customType);
    }
  }

  _handleWCheck() {
    if (!_isWChecked) {
      _isDChecked = false;
      _isWChecked = true;
      _isMChecked = false;
      _isYChecked = false;

      _ticks = _createWeekTick();
      _selectDay = _getDayString(_pickDate);
      _createWeekDataState(_pickDate, widget.itemType, widget.customType);
    }
  }

  _handleMCheck() {
    if (!_isMChecked) {
      _isDChecked = false;
      _isWChecked = false;
      _isMChecked = true;
      _isYChecked = false;

      _ticks = _createMonthTick(_pickDate);
      _selectDay = _getDayString(_pickDate);
      _createMonthDataState(_pickDate, widget.itemType, widget.customType);
    }
  }

  _handleYCheck() {
    if (!_isYChecked) {
      _isDChecked = false;
      _isWChecked = false;
      _isMChecked = false;
      _isYChecked = true;

      _ticks = _createYearTick();
      _selectDay = _getDayString(_pickDate);
      _createYearDataState(_pickDate, widget.itemType, widget.customType);
    }
  }

  _showDatePicker() {
    _selectDate(context);
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime _picked = await showDatePicker(
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime(2019),
      lastDate: new DateTime.now(),
      initialDatePickerMode: DatePickerMode.day,
    ).catchError((err) {
      print(err);
    });

    if (_picked != null) {
      _pickDate = _picked;
      _selectDay = _getDayString(_pickDate);
      if (_isDChecked) {
        _createDailyDataState(_pickDate, widget.itemType, widget.customType);
      } else if (_isWChecked) {
        _createWeekDataState(_pickDate, widget.itemType, widget.customType);
      } else if (_isMChecked) {
        _createMonthDataState(_pickDate, widget.itemType, widget.customType);
      } else if (_isYChecked) {
        _createYearDataState(_pickDate, widget.itemType, widget.customType);
      }
    }
  }

  List<charts.Series<ActivityData, String>> _createDailyEmptyData() {
    List<ActivityData> data = [];
    for (int i = 0; i < 24; i++) {
      if (i < 10) {
        data.add(new ActivityData('0' + i.toString(), 0, i));
      } else {
        data.add(new ActivityData(i.toString(), 0, i));
      }
    }

    return [
      new charts.Series<ActivityData, String>(
        id: 'Activity',
        colorFn: (_, __) => charts.Color(r: 0x13, g: 0xD0, b: 0x77, a: 0xFF),
        domainFn: (ActivityData sales, _) => sales.label,
        measureFn: (ActivityData sales, _) => sales.time,
        data: data,
      )
    ];
  }

  _createDailyDataState(DateTime dateTime, int type, int customType) async {
    List<ActivityData> data = await _loadDailyData(dateTime, type, customType);
    List<charts.Series<ActivityData, String>> list = [
      new charts.Series<ActivityData, String>(
        id: 'Activity',
        colorFn: (_, __) => charts.Color(r: 0x13, g: 0xD0, b: 0x77, a: 0xFF),
        domainFn: (ActivityData sales, _) => sales.label,
        measureFn: (ActivityData sales, _) => sales.time,
        data: data,
      )
    ];
    _setAverage(data);
    _seriesList = list;

    _checkNextEnable();

    setState(() {});
  }

  Future<List<ActivityData>> _loadDailyData(
      DateTime dateTime, int type, int customType) async {
    List<ActivityItem> dailyList = await (type == ActivityItem.TYPE_NONE
        ? _getDailyListByDay(dateTime)
        : _getDailyListByDayAndType(dateTime, type, customType));
    List<ActivityData> data = [];
    for (int i = 0; i < 24; i++) {
      if (i < 10) {
        data.add(new ActivityData('0' + i.toString(), 0, i));
      } else {
        data.add(new ActivityData(i.toString(), 0, i));
      }
    }
    if (type & ActivityItem.TYPE_OTHER_TOTAL != 0) {
      List<ActivityItem> sortList = [];
      for (ActivityItem item in dailyList) {
        ActivityItem tempItem;
        for (ActivityItem sortItem in sortList) {
          if (sortItem.type & ActivityItem.TYPE_CUSTOM != 0) {
            if (sortItem.type == item.type &&
                sortItem.customType == item.customType) {
              tempItem = sortItem;
              break;
            }
          } else if (sortItem.type == item.type) {
            tempItem = sortItem;
            break;
          }
        }
        if (tempItem == null) {
          tempItem = item;
          sortList.add(tempItem);
        } else {
          tempItem.actual += item.actual;
        }
      }
      sortList.sort((left, right) => right.actual.compareTo(left.actual));
      if (sortList.isNotEmpty && sortList.length > MAX_DETAIL_COUNT) {
        dailyList = sortList.sublist(MAX_DETAIL_COUNT);
      }
    }
    for (ActivityItem item in dailyList) {
      int timeInt = item.time;
      DateTime time = DateTime.fromMillisecondsSinceEpoch(timeInt);
      int actualSeconds = item.actual;
      int actualMins = actualSeconds ~/ 60;
      double tempTime = data[time.hour].time;//double.parse((data[time.hour].time).toStringAsFixed(0));
      tempTime += actualMins;
      data[time.hour].time = tempTime > 60 ? 60 : tempTime;
      double overTime = tempTime - 60;
      if (overTime > 0) {
        /// Add overTime on next hour
        int offset = 1;
        while (overTime > 0) {
          if (time.hour + offset >= data.length) break;
          tempTime = data[time.hour + offset].time;
          tempTime += overTime;
          data[time.hour + offset].time = tempTime > 60 ? 60 : tempTime;
          overTime = tempTime - 60;
          offset++;
        }
      }
    }
    return data;
  }

  Future<List<ActivityItem>> _getDailyListByDay(DateTime dateTime) async {
    List<ActivityItem> activities =
        await DatabaseHelper.internal().selectActivities();
    List<ActivityItem> dailyList = new List();
    for (ActivityItem item in activities) {
      int timeInt = item.time;
      if (item.actual < 60) continue;
      DateTime time = DateTime.fromMillisecondsSinceEpoch(timeInt);
      if (dateTime.year == time.year &&
          dateTime.month == time.month &&
          dateTime.day == time.day) {
        dailyList.add(item);
      }
    }
    return dailyList;
  }

  Future<List<ActivityItem>> _getDailyListByDayAndType(
      DateTime dateTime, int type, int customType) async {
    List<ActivityItem> activities =
        await DatabaseHelper.internal().selectActivities();
    List<ActivityItem> dailyList = new List();
    bool isIndoor = type & ActivityItem.TYPE_INDOOR != 0;
    for (ActivityItem item in activities) {
      int timeInt = item.time;
      int itemType = item.type;
      int itemCustom = item.customType;
      if (item.actual < 60) continue;
      DateTime time = DateTime.fromMillisecondsSinceEpoch(timeInt);
      if (dateTime.year == time.year &&
          dateTime.month == time.month &&
          dateTime.day == time.day) {
        if (itemType == type) {
          if (customType != 0) {
            if (itemCustom == customType) {
              dailyList.add(item);
            }
          } else {
            dailyList.add(item);
          }
        } else if (type & ActivityItem.TYPE_OTHER_TOTAL != 0) {
          if (isIndoor) {
            if (itemType & ActivityItem.TYPE_INDOOR != 0) {
              dailyList.add(item);
            }
          } else {
            if (itemType & ActivityItem.TYPE_OUTDOOR != 0) {
              dailyList.add(item);
            }
          }
        }
      }
    }
    return dailyList;
  }

  _createWeekDataState(DateTime dateTime, int type, int customType) async {
    List<ActivityData> data = await _loadWeekData(dateTime, type, customType);
    List<charts.Series<ActivityData, String>> list = [
      new charts.Series<ActivityData, String>(
        id: 'Activity',
        colorFn: (_, __) => charts.Color(r: 0x13, g: 0xD0, b: 0x77, a: 0xFF),
        domainFn: (ActivityData sales, _) => sales.label,
        measureFn: (ActivityData sales, _) => sales.time,
        data: data,
      )
    ];
    _setAverage(data);
    _seriesList = list;
    _checkNextEnable();

    setState(() {});
  }

  Future<List<ActivityData>> _loadWeekData(
      DateTime dateTime, int type, int customType) async {
    List<ActivityItem> dailyList = await (type == ActivityItem.TYPE_NONE
        ? _getDailyListByWeek(dateTime)
        : _getDailyListByWeekAndType(dateTime, type, customType));
    List<ActivityData> data = [
      new ActivityData('Sun', 0, 0),
      new ActivityData('Mon', 0, 1),
      new ActivityData('Tue', 0, 2),
      new ActivityData('Wed', 0, 3),
      new ActivityData('Thu', 0, 4),
      new ActivityData('Fri', 0, 5),
      new ActivityData('Sat', 0, 6),
    ];

    if (type & ActivityItem.TYPE_OTHER_TOTAL != 0) {
      List<ActivityItem> sortList = [];
      for (ActivityItem item in dailyList) {
        ActivityItem tempItem;
        for (ActivityItem sortItem in sortList) {
          if (sortItem.type & ActivityItem.TYPE_CUSTOM != 0) {
            if (sortItem.type == item.type &&
                sortItem.customType == item.customType) {
              tempItem = sortItem;
              break;
            }
          } else if (sortItem.type == item.type) {
            tempItem = sortItem;
            break;
          }
        }
        if (tempItem == null) {
          tempItem = item;
          sortList.add(tempItem);
        } else {
          tempItem.actual += item.actual;
        }
      }
      sortList.sort((left, right) => right.actual.compareTo(left.actual));
      if (sortList.isNotEmpty && sortList.length > MAX_DETAIL_COUNT) {
        dailyList = sortList.sublist(MAX_DETAIL_COUNT);
      }
    }

    for (ActivityItem item in dailyList) {
      int timeInt = item.time;
      DateTime time = DateTime.fromMillisecondsSinceEpoch(timeInt);
      int actualSeconds = item.actual;
      double actualHours = actualSeconds / (60 * 60);
//          double.parse((actualSeconds / (60 * 60)).toStringAsFixed(4));
      int index = time.weekday % 7;
      double tempTime = data[index].time;
      tempTime += actualHours;
      data[index].time = tempTime > 24 ? 24 : tempTime;
      double overTime = tempTime - 24;
      if (overTime > 0) {
        /// Add overTime on next day
        int offset = 1;
        while (overTime > 0) {
          index = (index + offset) % 7;
          if (index + offset >= data.length) break;
          tempTime = data[index].time;
          tempTime += overTime;
          data[index].time = tempTime > 24 ? 24 : tempTime;
          overTime = tempTime - 24;
          offset++;
        }
      }
    }
    return data;
  }

  Future<List<ActivityItem>> _getDailyListByWeek(DateTime dateTime) async {
    List<ActivityItem> activities =
        await DatabaseHelper.internal().selectActivities();
    List<ActivityItem> dailyList = new List();
    DateTime current = DateTime(dateTime.year, dateTime.month, dateTime.day);
    int weekDay = current.weekday;
    int leftDay = weekDay;
    int rightDay = 6 - weekDay;
    DateTime startDate = current.subtract(Duration(days: leftDay));
    DateTime endDate = current
        .add(Duration(days: rightDay, hours: 23, minutes: 59, seconds: 59));
    int startDateInt = startDate.millisecondsSinceEpoch;
    int endDateInt = endDate.millisecondsSinceEpoch;
    for (ActivityItem item in activities) {
      if (item.actual < 60) continue;
      if (startDateInt <= item.time && endDateInt >= item.time) {
        dailyList.add(item);
      }
    }
    return dailyList;
  }

  Future<List<ActivityItem>> _getDailyListByWeekAndType(
      DateTime dateTime, int type, int customType) async {
    List<ActivityItem> activities =
        await DatabaseHelper.internal().selectActivities();
    List<ActivityItem> dailyList = new List();
    DateTime current = DateTime(dateTime.year, dateTime.month, dateTime.day);
    int weekDay = current.weekday;
    int leftDay = weekDay;
    int rightDay = 6 - weekDay;
    DateTime startDate = current.subtract(Duration(days: leftDay));
    DateTime endDate = current
        .add(Duration(days: rightDay, hours: 23, minutes: 59, seconds: 59));
    int startDateInt = startDate.millisecondsSinceEpoch;
    int endDateInt = endDate.millisecondsSinceEpoch;
    bool isIndoor = type & ActivityItem.TYPE_INDOOR != 0;
    for (ActivityItem item in activities) {
      if (item.actual < 60) continue;
      if (startDateInt <= item.time && endDateInt >= item.time) {
        if (item.type == type) {
          if (customType != 0) {
            if (item.customType == customType) {
              dailyList.add(item);
            }
          } else {
            dailyList.add(item);
          }
        } else if (type & ActivityItem.TYPE_OTHER_TOTAL != 0) {
          if (isIndoor) {
            if (item.type & ActivityItem.TYPE_INDOOR != 0) {
              dailyList.add(item);
            }
          } else {
            if (item.type & ActivityItem.TYPE_OUTDOOR != 0) {
              dailyList.add(item);
            }
          }
        }
      }
    }
    return dailyList;
  }

  _createMonthDataState(DateTime dateTime, int type, int customType) async {
    List<ActivityData> data = await _loadMonthData(dateTime, type, customType);
    List<charts.Series<ActivityData, String>> list = [
      new charts.Series<ActivityData, String>(
        id: 'Activity',
        colorFn: (_, __) => charts.Color(r: 0x13, g: 0xD0, b: 0x77, a: 0xFF),
        domainFn: (ActivityData sales, _) => sales.label,
        measureFn: (ActivityData sales, _) => sales.time,
        data: data,
      )
    ];
    _setAverage(data);
    _seriesList = list;

    _checkNextEnable();

    setState(() {});
  }

  Future<List<ActivityData>> _loadMonthData(
      DateTime dateTime, int type, int customType) async {
    List<ActivityItem> dailyList = await (type == ActivityItem.TYPE_NONE
        ? _getDailyListByMonth(dateTime)
        : _getDailyListByMonthAndType(dateTime, type, customType));
    List<ActivityData> data = [];
    int dayCounts = getMonthDayCount(dateTime);
    for (int i = 1; i <= dayCounts; i++) {
      data.add(new ActivityData(i.toString(), 0, i));
    }

    if (type & ActivityItem.TYPE_OTHER_TOTAL != 0) {
      List<ActivityItem> sortList = [];
      for (ActivityItem item in dailyList) {
        ActivityItem tempItem;
        for (ActivityItem sortItem in sortList) {
          if (sortItem.type & ActivityItem.TYPE_CUSTOM != 0) {
            if (sortItem.type == item.type &&
                sortItem.customType == item.customType) {
              tempItem = sortItem;
              break;
            }
          } else if (sortItem.type == item.type) {
            tempItem = sortItem;
            break;
          }
        }
        if (tempItem == null) {
          tempItem = item;
          sortList.add(tempItem);
        } else {
          tempItem.actual += item.actual;
        }
      }
      sortList.sort((left, right) => right.actual.compareTo(left.actual));
      if (sortList.isNotEmpty && sortList.length > MAX_DETAIL_COUNT) {
        dailyList = sortList.sublist(MAX_DETAIL_COUNT);
      }
    }

    for (ActivityItem item in dailyList) {
      int timeInt = item.time;
      DateTime time = DateTime.fromMillisecondsSinceEpoch(timeInt);
      int actualSeconds = item.actual;
      double actualHours = actualSeconds / (60 * 60);
//          double.parse((actualSeconds / (60 * 60)).toStringAsFixed(2));
      int index = time.day;
      double tempTime = data[index].time;
      tempTime += actualHours;
      data[index].time = tempTime > 24 ? 24 : tempTime;
      double overTime = tempTime - 24;
      if (overTime > 0) {
        /// Add overTime on next day
        int offset = 1;
        while (overTime > 0) {
          index = index + offset;
          if (index + offset >= data.length) break;
          tempTime = data[index].time;
          tempTime += overTime;
          data[index].time = tempTime > 24 ? 24 : tempTime;
          overTime = tempTime - 24;
          offset++;
        }
      }
    }
    return data;
  }

  Future<List<ActivityItem>> _getDailyListByMonth(DateTime dateTime) async {
    List<ActivityItem> activities =
        await DatabaseHelper.internal().selectActivities();
    List<ActivityItem> dailyList = new List();
    for (ActivityItem item in activities) {
      if (item.actual < 60) continue;
      int timeInt = item.time;
      DateTime itemTime = DateTime.fromMillisecondsSinceEpoch(timeInt);
      if (itemTime.month == dateTime.month) {
        dailyList.add(item);
      }
    }
    return dailyList;
  }

  Future<List<ActivityItem>> _getDailyListByMonthAndType(
      DateTime dateTime, int type, int customType) async {
    List<ActivityItem> activities =
        await DatabaseHelper.internal().selectActivities();
    List<ActivityItem> dailyList = new List();
    bool isIndoor = type & ActivityItem.TYPE_INDOOR != 0;
    for (ActivityItem item in activities) {
      if (item.actual < 60) continue;
      int timeInt = item.time;
      DateTime itemTime = DateTime.fromMillisecondsSinceEpoch(timeInt);
      if (itemTime.month == dateTime.month) {
        if (item.type == type) {
          if (customType != 0) {
            if (item.customType == customType) {
              dailyList.add(item);
            }
          } else {
            dailyList.add(item);
          }
        } else if (type & ActivityItem.TYPE_OTHER_TOTAL != 0) {
          if (isIndoor) {
            if (item.type & ActivityItem.TYPE_INDOOR != 0) {
              dailyList.add(item);
            }
          } else {
            if (item.type & ActivityItem.TYPE_OUTDOOR != 0) {
              dailyList.add(item);
            }
          }
        }
      }
    }
    return dailyList;
  }

  _createYearDataState(DateTime dateTime, int type, int customType) async {
    List<ActivityData> data = await _loadYearData(dateTime, type, customType);
    List<charts.Series<ActivityData, String>> list = [
      new charts.Series<ActivityData, String>(
        id: 'Activity',
        colorFn: (_, __) => charts.Color(r: 0x13, g: 0xD0, b: 0x77, a: 0xFF),
        domainFn: (ActivityData sales, _) => sales.label,
        measureFn: (ActivityData sales, _) => sales.time,
        data: data,
      )
    ];
    _setAverage(data);
    _seriesList = list;

    _checkNextEnable();

    setState(() {});
  }

  Future<List<ActivityData>> _loadYearData(
      DateTime dateTime, int type, int customType) async {
    List<ActivityItem> dailyList = await (type == ActivityItem.TYPE_NONE
        ? _getDailyListByYear(dateTime)
        : _getDailyListByYearAndType(dateTime, type, customType));
    List<ActivityData> data = [];
    for (int i = 1; i <= 12; i++) {
      if (i == 3) {
        data.add(new ActivityData('Mar', 0, i));
      } else if (i == 6) {
        data.add(new ActivityData('Jun', 0, i));
      } else if (i == 9) {
        data.add(new ActivityData('Sep', 0, i));
      } else if (i == 12) {
        data.add(new ActivityData('Dec', 0, i));
      } else {
        data.add(new ActivityData(i.toString(), 0, i));
      }
    }

    if (type & ActivityItem.TYPE_OTHER_TOTAL != 0) {
      List<ActivityItem> sortList = [];
      for (ActivityItem item in dailyList) {
        ActivityItem tempItem;
        for (ActivityItem sortItem in sortList) {
          if (sortItem.type & ActivityItem.TYPE_CUSTOM != 0) {
            if (sortItem.type == item.type &&
                sortItem.customType == item.customType) {
              tempItem = sortItem;
              break;
            }
          } else if (sortItem.type == item.type) {
            tempItem = sortItem;
            break;
          }
        }
        if (tempItem == null) {
          tempItem = item;
          sortList.add(tempItem);
        } else {
          tempItem.actual += item.actual;
        }
      }
      sortList.sort((left, right) => right.actual.compareTo(left.actual));
      if (sortList.isNotEmpty && sortList.length > MAX_DETAIL_COUNT) {
        dailyList = sortList.sublist(MAX_DETAIL_COUNT);
      }
    }

    for (ActivityItem item in dailyList) {
      int timeInt = item.time;
      DateTime time = DateTime.fromMillisecondsSinceEpoch(timeInt);
      int dayCount = getMonthDayCount(time);
      int actualSeconds = item.actual;
      double actualHours = actualSeconds / (60 * 60);
//          double.parse((actualSeconds / (60 * 60)).toStringAsFixed(2));
      int index = time.month - 1;
      double tempTime = data[index].time;
      tempTime += actualHours;
      data[index].time =
          tempTime > (24 * dayCount) ? (24 * dayCount) : tempTime;
      double overTime = tempTime - (24 * dayCount);
      if (overTime > 0) {
        /// Add overTime on next day
        int offset = 1;
        while (overTime > 0) {
          index = index + offset;
          if (index + offset >= data.length) break;
          tempTime = data[index].time;
          tempTime += overTime;
          data[index].time =
              tempTime > (24 * dayCount) ? (24 * dayCount) : tempTime;
          overTime = tempTime - (24 * dayCount);
          offset++;
        }
      }
    }
    return data;
  }

  Future<List<ActivityItem>> _getDailyListByYear(DateTime dateTime) async {
    List<ActivityItem> activities =
        await DatabaseHelper.internal().selectActivities();
    List<ActivityItem> dailyList = new List();
    for (ActivityItem item in activities) {
      if (item.actual < 60) continue;
      int timeInt = item.time;
      DateTime itemTime = DateTime.fromMillisecondsSinceEpoch(timeInt);
      if (itemTime.year == dateTime.year) {
        dailyList.add(item);
      }
    }
    return dailyList;
  }

  Future<List<ActivityItem>> _getDailyListByYearAndType(
      DateTime dateTime, int type, int customType) async {
    List<ActivityItem> activities =
        await DatabaseHelper.internal().selectActivities();
    List<ActivityItem> dailyList = new List();
    bool isIndoor = type & ActivityItem.TYPE_INDOOR != 0;
    for (ActivityItem item in activities) {
      if (item.actual < 60) continue;
      int timeInt = item.time;
      DateTime itemTime = DateTime.fromMillisecondsSinceEpoch(timeInt);
      if (itemTime.year == dateTime.year) {
        if (item.type == type) {
          if (customType != 0) {
            if (item.customType == customType) {
              dailyList.add(item);
            }
          } else {
            dailyList.add(item);
          }
        } else if (type & ActivityItem.TYPE_OTHER_TOTAL != 0) {
          if (isIndoor) {
            if (item.type & ActivityItem.TYPE_INDOOR != 0) {
              dailyList.add(item);
            }
          } else {
            if (item.type & ActivityItem.TYPE_OUTDOOR != 0) {
              dailyList.add(item);
            }
          }
        }
      }
    }
    return dailyList;
  }

  List<charts.TickSpec<String>> _createDailyTick() {
    final staticTicks = <charts.TickSpec<String>>[];
    for (int i = 0; i < 24; i++) {
      if (i != 0 && i % 3 != 0) continue;
      if (i < 10) {
        staticTicks.add(charts.TickSpec('0' + i.toString()));
      } else {
        staticTicks.add(charts.TickSpec(i.toString()));
      }
    }
    return staticTicks;
  }

  List<charts.TickSpec<String>> _createWeekTick() {
    return <charts.TickSpec<String>>[
      charts.TickSpec('Sun'),
      charts.TickSpec('Mon'),
      charts.TickSpec('Tue'),
      charts.TickSpec('Wed'),
      charts.TickSpec('Thu'),
      charts.TickSpec('Fri'),
      charts.TickSpec('Sat')
    ];
  }

  List<charts.TickSpec<String>> _createMonthTick(DateTime time) {
    final staticTicks = <charts.TickSpec<String>>[];
    int dayCounts = getMonthDayCount(time);
    for (int i = 1; i <= dayCounts; i++) {
      if (i % 4 != 0) continue;
      staticTicks.add(charts.TickSpec(i.toString()));
    }
    return staticTicks;
  }

  List<charts.TickSpec<String>> _createYearTick() {
    return <charts.TickSpec<String>>[
      charts.TickSpec('Mar'),
      charts.TickSpec('Jun'),
      charts.TickSpec('Sep'),
      charts.TickSpec('Dec')
    ];
  }

  String _getDayString(DateTime time) {
    DateTime now = DateTime.now();
    String dayString = 'Today';
    if (_isDChecked) {
      if (time.year == now.year &&
          time.month == now.month &&
          time.day == now.day) {
        dayString = 'Today';
      } else {
        dayString = formatDate(time, [yyyy, '/', mm, '/', dd]);
      }
    } else if (_isWChecked) {
      DateTime current = DateTime(time.year, time.month, time.day);
      int weekDay = current.weekday;
      int leftDay = weekDay;
      int rightDay = 6 - weekDay;
      DateTime startDate = current.subtract(Duration(days: leftDay));
      DateTime endDate = current.add(Duration(days: rightDay));
      dayString = formatDate(startDate, [yyyy, '/', mm, '/', dd]) +
          '-' +
          formatDate(endDate, [yyyy, '/', mm, '/', dd]);
//      if (startDate.month == endDate.month && startDate.year == endDate.year) {
//        dayString =
//            '${monthShort[startDate.month - 1]} ${startDate.day}-${endDate.day}, ${startDate.year}';
//      } else if (startDate.year == endDate.year) {
//        dayString =
//            '${monthShort[startDate.month - 1]},${startDate.day}-${monthShort[endDate.month - 1]},${endDate.day} ${startDate.year}';
//      } else {
//        dayString =
//            '${monthShort[startDate.month - 1]},${startDate.day},${startDate.year}-${monthShort[endDate.month - 1]},${endDate.day}, ${endDate.year}';
//      }
    } else if (_isMChecked) {
      dayString = '${monthLong[time.month - 1]}';
    } else if (_isYChecked) {
      dayString = '${time.year}';
    }
    return dayString;
  }

  _setAverage(List<ActivityData> data) {
    double total = 0;
    for (ActivityData item in data) {
      total += item.time;
     }
    int averageTotal = 0;
    if (_isDChecked) {
      /// daily chart, the unit is minute
      averageTotal = total ~/ 1;// ~/ data.length;
    } else {
      /// Others, the unit is hour
      print('LJY total $total');
      averageTotal = (total * 60) ~/1;//data.length;
      print('LJY $averageTotal');
    }
    int hour = averageTotal ~/ 60;
    int min = averageTotal - (hour * 60);
    _averageHour = '$hour';
    _averageMin = '$min';
  }

  _setTitle() {
    String indoorText = widget.itemType & ActivityItem.TYPE_INDOOR != 0
        ? i18n.S.of(context).activity_indoor
        : i18n.S.of(context).activity_outdoor;
    if (widget.itemType == ActivityItem.TYPE_NONE) {
      _title = i18n.S.of(context).vision_status_title;
    } else {
      _title = getActivityTypeString(context, widget.itemType);
      if (widget.itemType & ActivityItem.TYPE_CUSTOM != 0) {
        _title = widget.customText;
      } else if (widget.itemType & ActivityItem.TYPE_OTHER_TOTAL != 0) {
        _title = i18n.S.of(context).activity_others;
      }
    }
    if (widget.itemType != 0) {
      _title = '$indoorText $_title';
    }
  }

  _handleLast() {
    if (!_lastEnable) return;
    DateTime dateTime =
        DateTime(_pickDate.year, _pickDate.month, _pickDate.day);
    int dayCount = getMonthDayCount(dateTime);
    if (_isDChecked) {
      dateTime = dateTime.subtract(Duration(days: 1));
    } else if (_isWChecked) {
      dateTime = dateTime.subtract(Duration(days: 7));
    } else if (_isMChecked) {
      dateTime = dateTime.subtract(Duration(days: dayCount));
    } else if (_isYChecked) {
      dateTime = DateTime(_pickDate.year - 1, _pickDate.month, _pickDate.day);
    }

    _pickDate = dateTime;
    _selectDay = _getDayString(_pickDate);

    if (_isDChecked) {
      _createDailyDataState(_pickDate, widget.itemType, widget.customType);
    } else if (_isWChecked) {
      _createWeekDataState(_pickDate, widget.itemType, widget.customType);
    } else if (_isMChecked) {
      _createMonthDataState(_pickDate, widget.itemType, widget.customType);
    } else if (_isYChecked) {
      _createYearDataState(_pickDate, widget.itemType, widget.customType);
    }
  }

  _handleNext() {
    if (!_nextEnable) return;
    DateTime dateTime =
        DateTime(_pickDate.year, _pickDate.month, _pickDate.day);
    int dayCount = getMonthDayCount(dateTime);
    if (_isDChecked) {
      dateTime = dateTime.add(Duration(days: 1));
    } else if (_isWChecked) {
      dateTime = dateTime.add(Duration(days: 7));
    } else if (_isMChecked) {
      dateTime = dateTime.add(Duration(days: dayCount));
    } else if (_isYChecked) {
      dateTime = DateTime(_pickDate.year + 1, _pickDate.month, _pickDate.day);
    }
    _pickDate = dateTime;
    _selectDay = _getDayString(_pickDate);

    if (_isDChecked) {
      _createDailyDataState(_pickDate, widget.itemType, widget.customType);
    } else if (_isWChecked) {
      _createWeekDataState(_pickDate, widget.itemType, widget.customType);
    } else if (_isMChecked) {
      _createMonthDataState(_pickDate, widget.itemType, widget.customType);
    } else if (_isYChecked) {
      _createYearDataState(_pickDate, widget.itemType, widget.customType);
    }
  }

  _checkNextEnable() {
    DateTime startDate = DateTime.now();
    DateTime dateTime =
        DateTime(_pickDate.year, _pickDate.month, _pickDate.day);
    int dayCount = getMonthDayCount(dateTime);
    if (_isDChecked) {
      dateTime = dateTime.add(Duration(days: 1));
    } else if (_isWChecked) {
      dateTime = dateTime.add(Duration(days: 7));
    } else if (_isMChecked) {
      dateTime = dateTime.add(Duration(days: dayCount));
    } else if (_isYChecked) {
      dateTime = DateTime(_pickDate.year + 1, _pickDate.month, _pickDate.day);
    }
    _nextEnable = dateTime.isBefore(startDate);
  }
}

class ActivityData {
  final String label;
  double time;
  final int index;

  ActivityData(this.label, this.time, this.index);
}
