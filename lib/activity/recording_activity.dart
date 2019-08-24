import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
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
  final String title;
  RecordingActivity({this.activityItem, this.title, this.isTargetChecked});

  @override
  _RecordingActivityState createState() => new _RecordingActivityState();
}

class _RecordingActivityState extends State<RecordingActivity>
    with SingleTickerProviderStateMixin {
  static const recordPlugin =
      const MethodChannel('com.myopia.flutter_myopia_ai/record');

  static const int TIMER_S = 59;
  static const int TIMER_M = 59;
  static const int TIMER_H = 99;

  List<charts.Series<LightConditionChart, int>> _seriesList;
  List<int> lightList = [];

  bool _isRunning = false;

  int _counterH = 0;
  int _counterM = 0;
  int _counterS = 0;
  int _timerCounter = 0;
  int _updateTime = 0;
  int _show202020Counter = 1;

  bool _isDialogShowing = false;
  bool _lightSensorValid = false;
  bool _isLightWarningShowing = false;
  bool _isLightRemind = true;
  bool _timesUpWarned = false;

  String _targetString = "";
  String _divider = ":";
  String _hour = '00';
  String _mins = '00';
  String _sec = '00';

  Color _mainColor;

  final TextStyle _counterStyle = const TextStyle(
    fontSize: 70,
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

  AudioCache _audioCache;
  AudioPlayer _audioPlayer;
  File _lightWarningAudio;
  File _warning20Audio;
  File _targetTimesUp;

  AnimationController _targetAnimController;

  _RecordingActivityState();

  @override
  void initState() {
    _show202020Counter = 1;
    _mainColor = getActivityColor(widget.activityItem.type);
    lightList.add(0);
    _seriesList = _createLightData();
    _targetString = _parseTargetTimeToString();
    _isRunning = true;
    _initAudioPlayer();
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
    _initAnim();
    super.initState();
  }

  _initAnim() {
    //AnimationController是一个特殊的Animation对象，在屏幕刷新的每一帧，就会生成一个新的值，
    // 默认情况下，AnimationController在给定的时间段内会线性的生成从0.0到1.0的数字
    //用来控制动画的开始与结束以及设置动画的监听
    //vsync参数，存在vsync时会防止屏幕外动画（动画的UI不在当前屏幕时）消耗不必要的资源
    //duration 动画的时长，这里设置的 seconds: 2 为2秒，当然也可以设置毫秒 milliseconds：2000.
    _targetAnimController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    //动画开始、结束、向前移动或向后移动时会调用StatusListener
    _targetAnimController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        //动画从 controller.forward() 正向执行 结束时会回调此方法
        _targetAnimController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        //动画从 controller.reverse() 反向执行 结束时会回调此方法
        _targetAnimController.forward();
      } else if (status == AnimationStatus.forward) {
        //执行 controller.forward() 会回调此状态
      } else if (status == AnimationStatus.reverse) {
        //执行 controller.reverse() 会回调此状态
      }
    });
  }

  _initAudioPlayer() async {
    _audioCache = new AudioCache();
    _audioPlayer = new AudioPlayer();
    _lightWarningAudio = await _audioCache.load('light_warning.mp3');
    _warning20Audio = await _audioCache.load('20_warning.mp3');
    _targetTimesUp = await _audioCache.load('target_times_up.mp3');
  }

  _releasePlayer() {
    if (_audioPlayer != null) {
      _audioPlayer.stop();
      _audioPlayer.release();
    }
    if (_audioCache != null) {
      _audioCache.clearCache();
    }
  }

  Future _playLocal(File file) async {
    await _audioPlayer.play(file.path, isLocal: true);
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
    if (!_isLightWarningShowing && _isLightRemind) {
      _isLightWarningShowing = true;
      if (_lightWarningAudio != null) {
        _playLocal(_lightWarningAudio);
      }
      _playVibrate();
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return DialogLightWarning(
            onConfirm: () => _isLightWarningShowing = false,
            onNotRemind: () => _isLightRemind = false,
          );
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
    _targetAnimController.dispose();
    _releasePlayer();
    _endRecord();
    _updateData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: new AppBar(
          backgroundColor: _mainColor,
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
              color: _mainColor,
              child: Stack(
                children: <Widget>[
                  getBackground(widget.activityItem.type),
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
                    height: 14,
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
        widget.title,
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
      offstage: !widget.isTargetChecked,
      child: Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.only(top: 10),
        child: ScaleTransition(
          scale: Tween(begin: 1.0, end: 0.8).animate(_targetAnimController),
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
                '$_targetString ${S.of(context).activity_remain}',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ],
          ),
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
                width: 126,
                height: 126,
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
                width: 126,
                height: 126,
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
                width: 126,
                height: 126,
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
    if (widget.isTargetChecked && widget.activityItem != null) {
      int targetInt = widget.activityItem.target;
      int hour = (targetInt ~/ (60 * 60)).toInt();
      int min = ((targetInt - hour * 60 * 60) ~/ 60).toInt();

      String hourString = hour > 0 ? (hour < 10 ? '0$hour' : '$hour') : '00';
      String minString = min > 0 ? (min < 10 ? '0$min' : '$min') : '00';

      targetTime = hourString + ":" + minString;
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
    Map<String, String> map = {"title": widget.title};
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

  Future<Null> _playVibrate() async {
    await recordPlugin.invokeMethod('playVibrate');
  }

  Future<Null> _hasLightSensor() async {
    bool temp = await recordPlugin.invokeMethod('hasLightSensor');
    _lightSensorValid = temp != null ? temp : false;
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
        _counterM == (20 * _show202020Counter) &&
        !_isDialogShowing) {
      _show20Dialog();
    }

    if (widget.isTargetChecked &&
        widget.activityItem != null &&
        !_timesUpWarned) {
      int targetInt =
          widget.activityItem.target - (_counterM * 60 + _counterH * 60 * 60);
      targetInt = targetInt < 0 ? 0 : targetInt;
      int hour = (targetInt ~/ (60 * 60)).toInt();
      int min = ((targetInt - hour * 60 * 60) ~/ 60).toInt();

      String hourString = hour > 0 ? (hour < 10 ? '0$hour' : '$hour') : '00';
      String minString = min > 0 ? (min < 10 ? '0$min' : '$min') : '00';

      if (hour <= 0 && min <= 0) {
        _targetAnimController.forward();
        _timesUpWarned = true;
        if (_targetTimesUp != null) {
          _playLocal(_targetTimesUp);
        }
        _playVibrate();
      }

      _targetString = hourString + ":" + minString;
    }
    _sec = _counterS < 10 ? '0$_counterS' : '$_counterS';
    _mins = _counterM < 10 ? '0$_counterM' : '$_counterM';
    _hour = _counterH < 10 ? '0$_counterH' : '$_counterH';
    setState(() {});
  }

  _show20Dialog() {
    _isDialogShowing = true;
    _show202020Counter++;
    if (_warning20Audio != null) {
      _playLocal(_warning20Audio);
    }
    _playVibrate();
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
        await DatabaseHelper.internal().getActivity(widget.activityItem.id);
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
    if (mounted) {
      setState(() {});
    }
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
