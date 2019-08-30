import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_myopia_ai/data/gl_data.dart';
import 'package:flutter_myopia_ai/exercise/dailog_exit_exercise.dart';
import 'package:flutter_myopia_ai/exercise/my_slide_transition.dart';
import 'package:flutter_myopia_ai/generated/i18n.dart';
import 'package:flutter_myopia_ai/util/myopia_const.dart';
import 'package:flutter_seekbar/flutter_seekbar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class EyeExercise extends StatefulWidget {
  @override
  _EyeExerciseState createState() => new _EyeExerciseState();
}

class _EyeExerciseState extends State<EyeExercise> {
  static const int _totalTimeZh = 334;
  static const int _stepTime1Zh = 105;
  static const int _stepTime2Zh = 172;
  static const int _stepTime3Zh = 244;
  static const int _totalTimeEn = 249;
  static const int _stepTime1En = 81;
  static const int _stepTime2En = 135;
  static const int _stepTime3En = 190;
  static const int _totalStep = 4;
  static const String _assetsLocalFilePathZh = "eye_exercise_music.mp3";
  static const String _assetsLocalFilePathEn = "eye_exercise_music_en.mp3";

  int _totalTime = _totalTimeEn;
  int _stepTime1 = _stepTime1En;
  int _stepTime2 = _stepTime2En;
  int _stepTime3 = _stepTime3En;
  String _assetsLocalFilePath = _assetsLocalFilePathEn;

  List<String> _titleList;
  List<Widget> _imageList;
  int _playingTime;
  int _step;
  double _progress;
  bool _playing;
  bool _pausing;
  IconData _actionIcon;
  Timer _timer;

  AudioCache _audioCache;
  AudioPlayer _audioPlayer;

  bool _isChinese = false;

  @override
  void initState() {
    _playing = false;
    _pausing = false;
    _progress = 0;
    _actionIcon = Icons.play_arrow;
    _step = 0;
    _playingTime = 0;
    _isChinese = GlobalData.getInstance().isLocaleChinese();
    if (_isChinese) {
      _totalTime = _totalTimeZh;
      _stepTime1 = _stepTime1Zh;
      _stepTime2 = _stepTime2Zh;
      _stepTime3 = _stepTime3Zh;
      _assetsLocalFilePath = _assetsLocalFilePathZh;
    } else {
      _totalTime = _totalTimeEn;
      _stepTime1 = _stepTime1En;
      _stepTime2 = _stepTime2En;
      _stepTime3 = _stepTime3En;
      _assetsLocalFilePath = _assetsLocalFilePathEn;
    }
    _initAudioPlayer();
    _initDelayStartTimer();
    super.initState();
  }

  void _initAudioPlayer() {
    _audioCache = new AudioCache();
    _audioPlayer = new AudioPlayer();
  }

  Future _playLocal() async {
    File file = await _audioCache.load(_assetsLocalFilePath);
    await _audioPlayer.play(file.path, isLocal: true);
  }

  Future _playPause() async {
    await _audioPlayer.pause();
  }

  Future _playSeek() async {
    await _audioPlayer.seek(Duration(seconds: _playingTime));
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer.cancel();
    }
    _audioPlayer.stop();
    _audioPlayer.release();
    _audioCache.clearCache();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _buildTitleAndImageList();
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: new AppBar(
          title: new Text(S.of(context).eye_exercise),
          backgroundColor: COLOR_MAIN_GREEN,
        ),
        body: _buildContent(),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (_playingTime >= _totalTime) {
      return Future.value(true);
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return DialogExitExercise(
            onCancel: () => {},
            onConfirm: () => _onConfirm(context),
          );
        },
      );
      return Future.value(false);
    }
  }

  _onConfirm(BuildContext bContext) {
    Navigator.of(this.context).pop();
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _buildSlideView(),
          SizedBox(
            height: 40,
          ),
          Container(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: _buildProgress(),
          ),
          SizedBox(
            height: 9,
          ),
          Container(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: _buildTime(),
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            child: InkWell(
              child: _buildPlayButton(),
              onTap: () {
                if (!_playing) {
                  _startTimer();
                } else {
                  _pauseTimer();
                }
                _actionIcon = _playing ? Icons.pause : Icons.play_arrow;
              },
            ),
          ),
          Offstage(
            offstage: _isChinese,
            child: SizedBox(
              height: 20,
            ),
          ),
          Offstage(
            offstage: _isChinese,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  S.of(context).eye_exercise_music_by,
                  style: TextStyle(
                    color: Color(0x7F999999),
                    fontSize: 12,
                  ),
                ),
                InkWell(
                  child: Text(
                    ' Svyat Ilin ',
                    style: TextStyle(
                      color: Color(0x7F2686DB),
                      fontSize: 12,
                    ),
                  ),
                  onTap: () {
                    _onPressSvyat();
                  },
                ),
                Text(
                  S.of(context).eye_exercise_from,
                  style: TextStyle(
                    color: Color(0x7F999999),
                    fontSize: 12,
                  ),
                ),
                InkWell(
                  child: Text(
                    ' Fugue',
                    style: TextStyle(
                      color: Color(0x7F2686DB),
                      fontSize: 12,
                    ),
                  ),
                  onTap: () {
                    _onPressFugue();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgress() {
    return SeekBar(
        progresseight: 2,
        indicatorRadius: 6.0,
        value: _progress,
        backgroundColor: Color(0x1913D077),
        progressColor: COLOR_MAIN_GREEN,
        onValueChanged: (v) {
          int tempTime = (_totalTime * (v.value / 100)) ~/ 1;
          if (tempTime > _totalTime) tempTime = _totalTime;
          _playingTime = tempTime;
          _playSeek();
          if (!_playing) _calculateProgress();
          setState(() {});
        });
  }

  Widget _buildTime() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          _parseTime(_playingTime),
          style: TextStyle(
            fontSize: 12,
            color: Color(0x7F212121),
          ),
        ),
        Text(
          _parseTime(_totalTime),
          style: TextStyle(
            fontSize: 12,
            color: Color(0x7F212121),
          ),
        ),
      ],
    );
  }

  Widget _buildPlayButton() {
    return AnimatedSwitcher(
      transitionBuilder: (child, anim) {
        return ScaleTransition(child: child, scale: anim);
      },
      duration: Duration(milliseconds: 300),
      child: Icon(
        _actionIcon,
        key: ValueKey(_actionIcon),
        color: COLOR_MAIN_GREEN,
        size: 36,
      ),
    );
  }

  Widget _buildSlideView() {
    return AnimatedSwitcher(
      transitionBuilder: (child, anim) {
        var tween = Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0));
        return MySlideTransition(child: child, position: tween.animate(anim));
      },
      duration: Duration(milliseconds: 300),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        key: ValueKey(_step),
        children: <Widget>[
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            padding: EdgeInsets.only(left: 40, top: 30, right: 40),
            child: Text(
              _titleList[_step],
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 16,
                color: Color(0xff191919),
              ),
            ),
          ),
          SizedBox(
            height: _step == (_totalStep - 1) ? 0 : 30,
          ),
          _imageList[_step],
        ],
      ),
    );
  }

  String _parseTime(int time) {
    int min = time ~/ 60;
    int sec = time - min * 60;
    String minString = min < 10 ? '0$min' : '$min';
    String secString = sec < 10 ? '0$sec' : '$sec';
    return '$minString:$secString';
  }

  _buildTitleAndImageList() {
    _titleList = [
      S.of(context).eye_exercise_step_1,
      S.of(context).eye_exercise_step_2,
      S.of(context).eye_exercise_step_3,
      S.of(context).eye_exercise_step_4,
    ];
    _imageList = [
      SvgPicture.asset(
        'assets/eye_exercise_1.svg',
        height: 330,
      ),
      SvgPicture.asset(
        'assets/eye_exercise_2.svg',
        height: 330,
      ),
      SvgPicture.asset(
        'assets/eye_exercise_3.svg',
        height: 330,
      ),
      SvgPicture.asset(
        'assets/eye_exercise_4.svg',
        height: 330,
      )
    ];
  }

  _playTimer() {
    _timer = Timer.periodic(new Duration(seconds: 1), (timer) {
      if (_playingTime >= _totalTime) {
        _playing = false;
        _actionIcon = Icons.play_arrow;
        setState(() {});
        timer.cancel();
      } else {
        _playingTime++;
        _calculateProgress();
        setState(() {});
      }
    });
  }

  _calculateProgress() {
    _progress = (_playingTime / _totalTime) * 100;
    if (_playingTime != 0 && _playingTime < _totalTime) {
      if (_playingTime >= _stepTime3) {
        _step = 3;
      } else if (_playingTime >= _stepTime2) {
        _step = 2;
      } else if (_playingTime >= _stepTime1) {
        _step = 1;
      } else {
        _step = 0;
      }
    }
  }

  _startTimer() {
    if (_playing) return;
    if (_playingTime >= _totalTime) {
      _playingTime = 0;
      _step = 0;
    }
    _pausing = false;
    _playing = true;
    setState(() {});
    _playTimer();
    _playLocal();
  }

  _initDelayStartTimer() {
    Timer(Duration(seconds: 1), () {
      _actionIcon = Icons.pause;
      _startTimer();
    });
  }

  _pauseTimer() {
    if (_pausing) return;
    _pausing = true;
    _playing = false;
    setState(() {});
    _playPause();
    if (_timer != null) _timer.cancel();
  }

  _onPressSvyat() async {
    const url = 'https://icons8.com/music/author/svyat-ilin';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _onPressFugue() async {
    const url = 'https://icons8.com/music';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
