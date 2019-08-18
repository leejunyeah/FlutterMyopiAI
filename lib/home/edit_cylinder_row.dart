import 'package:flutter/material.dart';
import 'package:flutter_myopia_ai/util/myopia_const.dart';

import 'package:flutter_myopia_ai/home/header_text.dart';
import 'package:flutter_myopia_ai/data/gl_data.dart';

import '../generated/i18n.dart';

class EditCylWidget extends StatefulWidget {
  EditCylWidget({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _EditCylWidgetState createState() => new _EditCylWidgetState();

  void cacheData() {
    glCylRight = rightCounter;
    glCylLeft = leftCounter;
  }
}

double leftCounter = 0;
double rightCounter = 0;

class _EditCylWidgetState extends State<EditCylWidget> {

  _EditCylWidgetState() {
    _initData();
  }

  void _incrementLCounter() {
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
    leftCounter = glCylLeft == null ? 0 : glCylLeft;
    rightCounter = glCylRight == null ? 0 : glCylRight;
  }

  @override
  Widget build(BuildContext context) {
    return buildSphRow();
  }

  Widget buildSphRow() {
    var cylRow = Padding(
      padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
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
                      color: INDOOR_COLOR_3,
                      size: 8,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    buildTextHeader(S.of(context).vision_cyl),
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
                  color: Color(0x4C21C8D4),
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
                              color: INDOOR_COLOR_3,
                              icon: Icon(
                                Icons.remove,
                                size: 20,
                              ),
                            ),
                            new Expanded(
                              child: new Text(
                                "$leftCounter",
                                textAlign: TextAlign.center,
                                style: STYLE_EDIT_ITEM,
                              ),
                            ),
                            new IconButton(
                              onPressed: () {
                                _incrementLCounter();
                              },
                              color: INDOOR_COLOR_3,
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
                              color: INDOOR_COLOR_3,
                              icon: Icon(
                                Icons.remove,
                                size: 20,
                              ),
                            ),
                            new Expanded(
                              child: new Text(
                                "$rightCounter",
                                textAlign: TextAlign.center,
                                style: STYLE_EDIT_ITEM,
                              ),
                            ),
                            new IconButton(
                              onPressed: () {
                                _incrementRCounter();
                              },
                              color: INDOOR_COLOR_3,
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
    return cylRow;
  }
}
