import 'package:flutter/material.dart';

import 'package:flutter_myopia_ai/data/gl_data.dart';
import 'package:flutter_myopia_ai/home/result_tips.dart';
import 'package:flutter_myopia_ai/util/date_format.dart';
import 'package:flutter_myopia_ai/util/myopia_const.dart';
import '../main_page.dart';
import 'edit_myopia.dart';
import '../generated/i18n.dart' as i18n;

class ResultMyopia extends StatefulWidget {
  final bool fromWelcome;
  final bool fromHome;

  ResultMyopia({this.fromWelcome: false, this.fromHome: false});

  @override
  _ResultState createState() => new _ResultState();
}

class _ResultState extends State<ResultMyopia>
    with SingleTickerProviderStateMixin {
  String result = '';

  @override
  Widget build(BuildContext context) {
    _initData();
    return WillPopScope(
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text(i18n.S.of(context).vision_status_title),
          backgroundColor: COLOR_MAIN_GREEN,
        ),
        body: ListView(
          children: <Widget>[
            _buildTitleCard(),
            new ResultTips(),
          ],
        ),
      ),
      onWillPop: _requestPop,
    );
  }

  Future<bool> _requestPop() {
    if (widget.fromWelcome) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => MainPage()),
        (Route<dynamic> route) => false,
      );
    } else if (widget.fromHome) {
      Navigator.pop(context, HOME_TO_RESULT);
    } else {
      Navigator.pop(context);
    }
    return new Future.value(false);
  }

  @override
  void initState() {
    super.initState();
//    _initData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildTitleCard() {
    var card = Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 10.0),
      child: new Card(
        elevation: 4.0, //设置阴影
        shape: CARD_SHAPE,
        child: Padding(
          padding: const EdgeInsets.only(
              left: 16.0, top: 8.0, right: 16.0, bottom: 8.0),
          child: new Column(
            children: <Widget>[
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.assignment,
                        color: COLOR_MAIN_GREEN,
                      ),
                      SizedBox(
                        width: 19,
                      ),
                      new Text(
                        "$result",
                        style: TextStyle(
                          color: COLOR_RESULT_TITLE,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  new IconButton(
                    icon: Icon(Icons.edit),
                    color: COLOR_MAIN_GREEN,
                    onPressed: _gotoEdit,
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: new Divider(
                  height: 1,
                  color: Color(0x4C13D077),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.only(left: 6, top: 18.0, right: 6),
                child: new Row(
                  children: <Widget>[
                    new SizedBox(
                      width: 140,
                      height: 1,
                    ),
                    new Expanded(
                      flex: 1,
                      child: new Text(
                        //"LEFT/RIGHT",
                        i18n.S.of(context).vision_left_right,
                        style: STYLE_RESULT_HEADER,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ),
              new Padding(
                padding: const EdgeInsets.only(left: 6, top: 18.0, right: 6),
                child: new Row(
                  children: <Widget>[
                    new Container(
                      width: 140,
                      child: new Text(
                        //"Sphere(SPH)",
                        i18n.S.of(context).vision_sph,
                        style: STYLE_RESULT_HEADER,
                      ),
                    ),
                    new Expanded(
                      flex: 1,
                      child: new Text(
                        glSphLeft.toString() + "/" + glSphRight.toString(),
                        style: STYLE_RESULT_DETAIL,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ),
              new Padding(
                padding: const EdgeInsets.only(left: 6, top: 24.0, right: 6),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Container(
                      width: 140,
                      child: new Text(
                        //"Cylinder(CYL)",
                        i18n.S.of(context).vision_cyl,
                        style: STYLE_RESULT_HEADER,
                      ),
                    ),
                    new Expanded(
                      flex: 1,
                      child: new Text(
                        glCylLeft.toString() + "/" + glCylRight.toString(),
                        style: STYLE_RESULT_DETAIL,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ),
              new Padding(
                padding: const EdgeInsets.only(left: 6, top: 24.0, right: 6),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Container(
                      width: 140,
                      child: new Text(
                        //"Axis(AX)",
                        i18n.S.of(context).vision_ax,
                        style: STYLE_RESULT_HEADER,
                      ),
                    ),
                    new Expanded(
                      flex: 1,
                      child: new Text(
                        glAxLeft.toString() + "/" + glAxRight.toString(),
                        style: STYLE_RESULT_DETAIL,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ),
              new Padding(
                padding: const EdgeInsets.only(left: 6, top: 24.0, right: 6),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Container(
                      width: 140,
                      child: new Text(
                        //"ADD",
                        i18n.S.of(context).vision_add,
                        style: STYLE_RESULT_HEADER,
                      ),
                    ),
                    new Expanded(
                      flex: 1,
                      child: new Text(
                        glAddLeft.toString() + "/" + glAddRight.toString(),
                        style: STYLE_RESULT_DETAIL,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ),
              new Padding(
                padding: const EdgeInsets.only(left: 6, top: 24.0, right: 6),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Container(
                      width: 140,
                      child: new Text(
                        //"Pupillary distance(PD)",
                        i18n.S.of(context).vision_pd,
                        style: STYLE_RESULT_HEADER,
                      ),
                    ),
                    new Expanded(
                      flex: 1,
                      child: new Text(
                        glPd == null ? '0 mm' : glPd.toString() + ' mm',
                        style: STYLE_RESULT_DETAIL,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ),
              new Padding(
                padding: const EdgeInsets.only(left: 6, top: 24.0, right: 6),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Container(
                      width: 140,
                      child: new Text(
                        //"Time",
                        i18n.S.of(context).vision_time,
                        style: STYLE_RESULT_HEADER,
                      ),
                    ),
                    new Expanded(
                      flex: 1,
                      child: new Text(
                        glCreateTime == null || glCreateTime == ""
                            ? ""
                            : formatDate(DateTime.parse(glCreateTime), [
                                yyyy,
                                '/',
                                mm,
                                '/',
                                dd,
                                ' ',
                                hh,
                                ':',
                                mm,
                                ":",
                                s
                              ]),
                        style: STYLE_RESULT_DETAIL,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    return card;
  }

  _gotoEdit() async {
    int result = await Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => new EditMyopia(
                  fromWelcome: widget.fromWelcome,
                  fromResult: true,
                )));
    if (result == RESULT_TO_EDIT) {
//      _initData();
      setState(() {});
    }
  }

  _initData() {
    if (glResult == LEVEL_MILD) {
      result = i18n.S.of(context).result_mild;
    } else if (glResult == LEVEL_MODERATE) {
      result = i18n.S.of(context).result_moderate;
    } else if (glResult == LEVEL_HIGH) {
      result = i18n.S.of(context).result_high;
    } else {
      result = i18n.S.of(context).result_normal;
    }
  }
}
