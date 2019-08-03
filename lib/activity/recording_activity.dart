import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_myopia_ai/activity/dailog_exit_recording.dart';
import 'package:flutter_myopia_ai/activity/dailog_light_warning.dart';
import 'package:flutter_myopia_ai/activity/dialog_content_20.dart';
import 'package:flutter_myopia_ai/data/activity_item.dart';
import 'package:flutter_myopia_ai/data/database_helper.dart';
import 'package:flutter_myopia_ai/data/gl_data.dart';
import 'package:flutter_myopia_ai/util/myopia_const.dart';
import 'package:flutter_myopia_ai/activity/light_condition.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import '../generated/i18n.dart';

class RecordingActivity extends StatefulWidget {
  final bool isTargetChecked;
  final ActivityItem activityItem;
  RecordingActivity({this.activityItem, this.isTargetChecked});

  @override
  _RecordingActivityState createState() => new _RecordingActivityState(
      activityItem: activityItem, isTargetChecked: isTargetChecked);
}

class _RecordingActivityState extends State<RecordingActivity> {
  static const recordPlugin =
      const MethodChannel('com.myopia.flutter_myopia_ai/record');

  static const int TIMER_S = 59;
  static const int TIMER_M = 59;
  static const int TIMER_H = 99;

  final ActivityItem activityItem;
  final bool isTargetChecked;

  List<charts.Series<LightConditionChart, int>> _seriesList;
  List<int> lightList = [];

  bool _isRunning = false;

  int _counterH = 0;
  int _counterM = 0;
  int _counterS = 0;
  int _timerCounter = 0;
  int _updateTime = 0;

  bool _isDialogShowing = false;
  bool _lightSensorValid = false;
  bool _isLightWarningShowing = false;

  String _targetString = "";
  String _divider = ":";
  String _hour = '00';
  String _mins = '00';
  String _sec = '00';

  String _recordingType = '';

  final TextStyle _counterStyle = const TextStyle(
    fontSize: 72,
    color: Colors.white,
  );

  static const endRecordPlugin =
      const EventChannel('com.myopia.flutter_myopia_ai/end_record_plugin');
  static const lightPlugin =
      const EventChannel('com.myopia.flutter_myopia_ai/light_plugin');
  static const timerPlugin =
      const EventChannel('com.myopia.flutter_myopia_ai/timer_plugin');
  static const lightWarningPlugin =
      const EventChannel('com.myopia.flutter_myopia_ai/light_warning_plugin');

  _RecordingActivityState({this.activityItem, this.isTargetChecked});

  @override
  void initState() {
    lightList.add(0);
    _seriesList = _createLightData();
    _isRunning = true;
    _targetString = _parseTargetTimeToString();
    _startRecord();
    endRecordPlugin
        .receiveBroadcastStream()
        .listen(_onEvent, onError: _onError);
    lightPlugin
        .receiveBroadcastStream()
        .listen(_onLightEvent, onError: _onError);
    timerPlugin
        .receiveBroadcastStream()
        .listen(_onTimerUpdate, onError: _onError);
    lightWarningPlugin
        .receiveBroadcastStream()
        .listen(_onLightWarning, onError: _onError);
    _hasLightSensor();
    super.initState();
  }

  _onEvent(Object event) {
    _isRunning = false;
    _updateData();
    Navigator.pop(context, HOME_TO_START_ACTIVITY);
  }

  _onLightEvent(Object event) {
    int value = event as int;
    if (lightList.length > 60) {
      lightList.removeAt(0);
    }
    lightList.add(value);
    Future.delayed(const Duration(milliseconds: 500), () {
      _updateLightSensor();
      setState(() {});
    });
  }

  _onTimerUpdate(Object event) {
    _timerCounter = event as int;
    _updateCounter();
  }

  _onLightWarning(Object event) {
    if (!_isLightWarningShowing) {
      _isLightWarningShowing = true;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return DialogLightWarning(onConfirm: () => _isLightWarningShowing = false,);
        },
      );
    }
  }

  _onError(Object error) {
    ///TODO, junye.li
  }

  @override
  void dispose() {
    _isRunning = false;
    _endRecord();
    _updateData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _recordingType = getActivityTypeString(context, this.activityItem.type);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: new AppBar(
          backgroundColor: getActivityColor(activityItem.type),
          elevation: 0,
        ),
        body: _buildBodyContent(),
      ),
    );
  }

  Widget _buildBodyContent() {
    var body = Center(
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.only(left: 32, right: 32),
              color: getActivityColor(activityItem.type),
              child: Stack(
                children: <Widget>[
                  getBackground(activityItem.type),
                  Column(
                    children: <Widget>[
                      _buildTitle(),
                      _buildTarget(),
                      _buildTimerCounter(),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              child: Column(
                children: <Widget>[
                  Offstage(
                    offstage: !_lightSensorValid,
                    child: LightConditionWidget(
                      seriesList: _seriesList,
                    ),
                  ),
                  SizedBox(
                    height: 22,
                  ),
                  Expanded(
                    flex: 1,
                    child: _buildStartButton(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
    return body;
  }

  Widget _buildTitle() {
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.only(top: 40),
      child: Text(
        _recordingType,
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildTarget() {
    return Offstage(
      offstage: !this.isTargetChecked,
      child: Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.only(top: 10),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.timer,
              color: Colors.white,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              '${S.of(context).activity_target} $_targetString',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimerCounter() {
    return Container(
      padding: EdgeInsets.only(top: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            _hour,
            style: _counterStyle,
          ),
          Text(
            _divider,
            style: _counterStyle,
          ),
          Text(
            _mins,
            style: _counterStyle,
          ),
          Text(
            _divider,
            style: _counterStyle,
          ),
          Text(
            _sec,
            style: _counterStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildStartButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Offstage(
          offstage: !_isRunning,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SizedBox(
                width: 120,
                height: 120,
                child: FlatButton(
                  color: Color(0xE2F82E47),
                  highlightColor: Color(0xFFF82E47),
                  colorBrightness: Brightness.dark,
                  splashColor: Colors.grey,
                  child: Text(
                    //"STOP",
                    S.of(context).stop,
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                  shape: CircleBorder(),
                  onPressed: _handleStop,
                ),
              ),
            ],
          ),
        ),
        Offstage(
          offstage: _isRunning,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SizedBox(
                width: 120,
                height: 120,
                child: FlatButton(
                  color: COLOR_MAIN_GREEN,
                  highlightColor: Colors.green[200],
                  colorBrightness: Brightness.dark,
                  splashColor: Colors.grey,
                  child: Text(
                    //"CONTINUE",
                    S.of(context).s_continue,
                    style: TextStyle(fontSize: 18),
                  ),
                  shape: CircleBorder(),
                  onPressed: _handleContinue,
                ),
              ),
              SizedBox(
                width: 40,
              ),
              SizedBox(
                width: 120,
                height: 120,
                child: FlatButton(
                  color: Color(0xE2F82E47),
                  highlightColor: Color(0xFFF82E47),
                  colorBrightness: Brightness.dark,
                  splashColor: Colors.grey,
                  child: Text(
                    //"END",
                    S.of(context).end,
                    style: TextStyle(fontSize: 18),
                  ),
                  shape: CircleBorder(),
                  onPressed: _handleEnd,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _parseTargetTimeToString() {
    String targetTime = "";
    if (isTargetChecked && activityItem != null) {
      int targetInt = activityItem.target;
      int hour = (targetInt ~/ (60 * 60)).toInt();
      int min = ((targetInt - hour * 60 * 60) ~/ 60).toInt();
      String hourString = hour > 0 ? hour.toString() + S.of(context).time_h : '';
      String minString = min > 0 ? min.toString() + S.of(context).time_mins : '';
      targetTime =
          hourString.length > 0 ? hourString + ' ' + minString : minString;
    }
    return targetTime;
  }

  void _handleStop() {
    this._isRunning = false;
    _stopRecord();
    setState(() {});
  }

  void _handleEnd() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return DialogExitRecording(
          onCancel: () => {},
          onConfirm: () => _onConfirm(context),
        );
      },
    );
  }

  void _handleContinue() {
    this._isRunning = true;
    _continueRecord();
    setState(() {});
  }

  Future<Null> _startRecord() async {
    Map<String, String> map = {"title": _recordingType};
    await recordPlugin.invokeMethod('startRecord', map);
  }

  Future<Null> _stopRecord() async {
    await recordPlugin.invokeMethod('stopRecord');
  }

  Future<Null> _endRecord() async {
    await recordPlugin.invokeMethod('endRecord');
  }

  Future<Null> _continueRecord() async {
    await recordPlugin.invokeMethod('continueRecord');
  }

  Future<Null> _hasLightSensor() async {
    _lightSensorValid = await recordPlugin.invokeMethod('hasLightSensor');
    setState(() {});
  }

  _updateCounter() {
    _counterH = _timerCounter ~/ (60 * 60);
    _counterM = (_timerCounter - _counterH * (60 * 60)) ~/ 60;
    _counterS = _timerCounter - _counterH * (60 * 60) - _counterM * 60;

    _updateTime++;
    if (_updateTime >= 10) {
      _updateTime = 0;
      _updateData();
    }

    if ((gl202020 == null || gl202020) &&
        _counterM != 0 &&
        _counterM % 20 == 0 &&
        !_isDialogShowing) {
      _show20Dialog();
    }

    if (isTargetChecked && activityItem != null) {
      int targetInt =
          activityItem.target - (_counterM * 60 + _counterH * 60 * 60);
      targetInt = targetInt < 0 ? 0 : targetInt;
      int hour = (targetInt ~/ (60 * 60)).toInt();
      int min = ((targetInt - hour * 60 * 60) ~/ 60).toInt();
      String hourString = hour > 0 ? hour.toString() + S.of(context).time_h : '';
      String minString = min > 0 ? min.toString() + S.of(context).time_mins : '';
      _targetString =
          hourString.length > 0 ? hourString + ' ' + minString : minString;
    }

    setState(() {
      _sec = _counterS < 10 ? '0$_counterS' : '$_counterS';
      _mins = _counterM < 10 ? '0$_counterM' : '$_counterM';
      _hour = _counterH < 10 ? '0$_counterH' : '$_counterH';
    });
  }

  _show20Dialog() {
    _isDialogShowing = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return DialogContent(
          onClosed: () => _on20Closed(),
        );
      },
    );
  }

  _on20Closed() {
    _isDialogShowing = false;
  }

  _updateData() async {
    ActivityItem activityItem =
        await DatabaseHelper.internal().getActivity(this.activityItem.id);
    int totalTime = _counterS + _counterM * 60 + _counterH * 60 * 60;
    activityItem.actual = totalTime;
    await DatabaseHelper.internal().updateActivity(activityItem);
  }

  Future<bool> _onWillPop() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return DialogExitRecording(
          onCancel: () => {},
          onConfirm: () => _onConfirm(context),
        );
      },
    );
    return Future.value(false);
  }

  _onConfirm(BuildContext bContext) {
    Navigator.of(this.context).pop(HOME_TO_START_ACTIVITY);
  }

  _updateLightSensor() {
    _seriesList = _createLightData();
    setState(() {});
  }

  List<charts.Series<LightConditionChart, int>> _createLightData() {
    List<LightConditionChart> data = [];
    for (int i = 0; i < lightList.length; i++) {
      data.add(new LightConditionChart(i, lightList[i]));
    }

    return [
      new charts.Series<LightConditionChart, int>(
        id: 'Condition',
        colorFn: (_, __) => charts.Color(r: 0x13, g: 0xD0, b: 0x77, a: 0xFF),
        domainFn: (LightConditionChart condition, _) => condition.time,
        measureFn: (LightConditionChart condition, _) => condition.lightValue,
        data: data,
      )
    ];
  }
}
