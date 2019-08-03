import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_myopia_ai/util/myopia_const.dart';

import '../generated/i18n.dart';

class DialogContent extends StatefulWidget {
  final Function onClosed;

  DialogContent({this.onClosed});

  @override
  State<StatefulWidget> createState() => DialogContentState();
}

class DialogContentState extends State<DialogContent> {
  Function _onClosed;
  Timer _20Timer;
  int _counterS;
  bool _isRunning;

  @override
  void initState() {
    _counterS = 20;
    _isRunning = false;
    _onClosed = widget.onClosed;
    super.initState();
  }

  @override
  void dispose() {
    if (_20Timer != null) {
      _20Timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Material(
        type: MaterialType.transparency, //设置透明的效果
        child: Center(
          // 让子控件显示到中间
          child: SizedBox(
            //比较常用的一个控件，设置具体尺寸
            width: 280,
            height: 583,
            child: Container(
              padding:
                  EdgeInsets.only(left: 16, top: 20, right: 16, bottom: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      child: Container(
                        height: 27,
                        width: 27,
                        padding: EdgeInsets.all(7),
                        child: Icon(
                          Icons.close,
                          color: Colors.black,
                          size: 13,
                        ),
                      ),
                      onTap: () => _handleClose(),
                    ),
                  ),
                  SizedBox(
                    height: 13,
                  ),
                  Text(
                    '20/20/20',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xDD000000),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 8, right: 8),
                    child: Text(
                      //'Please take a break to look into the distance for 20 seconds at something 20 yards(18 meters) away',
                      S.of(context).activity_202020_msg,
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0x89000000),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    child: Image.asset('images/img_20_20_20.png'),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  _buildCounter(),
                  SizedBox(
                    height: 22,
                  ),
                  _buildStartButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCounter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          '00:',
          style: TextStyle(
            fontSize: 56,
            color: Color(0xA5000000),
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          _counterS < 10 ? '0$_counterS' : '$_counterS',
          style: TextStyle(
            fontSize: 56,
            color: Color(0xA5000000),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildStartButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
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
                    //"START",
                    S.of(context).start,
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                  shape: CircleBorder(),
                  onPressed: () => _handleStart(),
                ),
              ),
            ],
          ),
        ),
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
                    //"END",
                    S.of(context).end,
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                  shape: CircleBorder(),
                  onPressed: () => _handleEnd(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _handleClose() {
    _counterS = 20;
    _isRunning = false;
    if (_20Timer != null) {
      _20Timer.cancel();
    }
    _onClosed();
    Navigator.of(context).pop();
  }

  _handleStart() {
    _counterS = 20;
    _isRunning = true;
    _start20Timer();
    setState(() {});
  }

  _handleEnd() {
    _counterS = 20;
    _isRunning = false;
    if (_20Timer != null) {
      _20Timer.cancel();
    }
    setState(() {});
  }

  _start20Timer() {
    _20Timer = Timer.periodic(new Duration(seconds: 1), (timer) {
      _counterS--;
      if (_counterS <= 0) {
        _counterS = 20;
        _isRunning = false;
        timer.cancel();
      }
      setState(() {});
    });
  }
}
