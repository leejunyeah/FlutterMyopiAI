import 'package:flutter/material.dart';
import 'package:flutter_myopia_ai/home/dailog_warning.dart';
import 'package:flutter_myopia_ai/util/myopia_const.dart';

import 'package:flutter_myopia_ai/home/header_text.dart';
import 'package:flutter_myopia_ai/data/gl_data.dart';
import '../generated/i18n.dart';

class EditSphWidget extends StatefulWidget {
  EditSphWidget({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _EditSphWidgetState createState() => new _EditSphWidgetState();

  void cacheData() {
    glSphRight = rightCounter;
    glSphLeft = leftCounter;
  }
}

double leftCounter = 0;
double rightCounter = 0;

class _EditSphWidgetState extends State<EditSphWidget> {
  
  bool _leftWarningConfirm;
  bool _rightWarningConfirm;
  
  @override
  void initState() {
    _initData();
    super.initState();
  }

  void _incrementLCounter() {
    if (leftCounter + 0.25 > 0 && !_leftWarningConfirm) {
      _showLWarningDialog();
      return;
    }
    setState(() {
      leftCounter += 0.25;
    });
  }

  void _decrementLCounter() {
    setState(() {
      leftCounter -= 0.25;
    });
  }

  void _incrementRCounter() {
    if (rightCounter + 0.25 > 0 && !_rightWarningConfirm) {
      _showRWarningDialog();
      return;
    }
    setState(() {
      rightCounter += 0.25;
    });
  }

  void _decrementRCounter() {
    setState(() {
      rightCounter -= 0.25;
    });
  }

  void _initData() {
    _leftWarningConfirm = false;
    _rightWarningConfirm = false;
    leftCounter = glSphLeft == null ? 0 : glSphLeft;
    rightCounter = glSphRight == null ? 0 : glSphRight;
  }

  void _showLWarningDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return DialogWarning(
          content:
          //'You are entering a postive value, are you sure this is correct?',
          S.of(context).sph_warning,
          onConfirm: () => _leftWarningConfirm = true,
        );
      },
    );
  }

  void _showRWarningDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return DialogWarning(
          content:
          //'You are entering a postive value, are you sure this is correct?',
          S.of(context).sph_warning,
          onConfirm: () => _rightWarningConfirm = true,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildSphRow();
  }

  Widget buildSphRow() {
    var sphRow = Padding(
      padding: EdgeInsets.all(16),
      child: Card(
        elevation: 4.0, //设置阴影
        shape: CARD_SHAPE,
        child: Padding(
          padding: EdgeInsets.only(left: 4, top: 8, right: 4, bottom: 8),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 12, right: 12),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.brightness_1,
                      color: COLOR_MAIN_GREEN,
                      size: 8,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    buildTextHeader(S.of(context).vision_sph),
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: EdgeInsets.only(left: 12, right: 12),
                child: Divider(
                  height: 1,
                  color: Color(0x4C13D077),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: <Widget>[
                        buildLeftHeader(context),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new IconButton(
                              onPressed: () {
                                _decrementLCounter();
                              },
                              color: COLOR_MAIN_GREEN,
                              icon: Icon(
                                Icons.remove,
                                size: 20,
                              ),
                            ),
                            new Expanded(
                              child: new Text(
                                leftCounter > 0 ? "+$leftCounter" : "$leftCounter",
                                textAlign: TextAlign.center,
                                style: STYLE_EDIT_ITEM,
                              ),
                            ),
                            new IconButton(
                              onPressed: () {
                                _incrementLCounter();
                              },
                              color: COLOR_MAIN_GREEN,
                              icon: Icon(
                                Icons.add,
                                size: 20,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: <Widget>[
                        buildRightHeader(context),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new IconButton(
                              onPressed: () {
                                _decrementRCounter();
                              },
                              color: COLOR_MAIN_GREEN,
                              icon: Icon(
                                Icons.remove,
                                size: 20,
                              ),
                            ),
                            new Expanded(
                              child: new Text(
                                rightCounter > 0 ? "+$rightCounter" : "$rightCounter",
                                textAlign: TextAlign.center,
                                style: STYLE_EDIT_ITEM,
                              ),
                            ),
                            new IconButton(
                              onPressed: () {
                                _incrementRCounter();
                              },
                              color: COLOR_MAIN_GREEN,
                              icon: Icon(
                                Icons.add,
                                size: 20,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    return sphRow;
  }
}
