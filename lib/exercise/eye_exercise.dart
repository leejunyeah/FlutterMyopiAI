import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_myopia_ai/exercise/my_slide_transition.dart';
import 'package:flutter_myopia_ai/generated/i18n.dart';
import 'package:flutter_myopia_ai/util/myopia_const.dart';
import 'package:flutter_seekbar/flutter_seekbar.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EyeExercise extends StatefulWidget {
  @override
  _EyeExerciseState createState() => new _EyeExerciseState();
}

class _EyeExerciseState extends State<EyeExercise> {
  static const int _totalTime = 334;
  static const int _stepTime1 = 105;
  static const int _stepTime2 = 172;
  static const int _stepTime3 = 244;
  static const int _totalStep = 4;
  static const String _assetsLocalFilePath = "eye_exercise_music.mp3";

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

  bool isMuted = false;

  @override
  void initState() {
    _playing = false;
    _pausing = false;
    _progress = 0;
    _actionIcon = Icons.play_arrow;
    _step = 0;
    _playingTime = 0;
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
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(S.of(context).eye_exercise),
          backgroundColor: COLOR_MAIN_GREEN,
        ),
        body: Column(
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
          ],
        ));
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
}
