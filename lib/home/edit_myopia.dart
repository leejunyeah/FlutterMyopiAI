import 'package:flutter/material.dart';
import 'package:flutter_myopia_ai/main_page.dart';
import 'package:flutter_myopia_ai/util/myopia_const.dart';

import 'package:flutter_myopia_ai/home/edit_sph_row.dart';
import 'package:flutter_myopia_ai/home/edit_cylinder_row.dart';
import 'package:flutter_myopia_ai/home/edit_axis_row.dart';
import 'package:flutter_myopia_ai/home/edit_add_row.dart';
import 'package:flutter_myopia_ai/home/edit_pd_row.dart';

import 'package:flutter_myopia_ai/data/gl_data.dart';
import 'result_myopia.dart';

import '../generated/i18n.dart';

class EditMyopia extends StatefulWidget {
  final bool fromWelcome;
  final bool fromResult;
  final bool fromHome;

  EditMyopia(
      {this.fromWelcome: false, this.fromResult: false, this.fromHome: false});

  @override
  EditMyopiaState createState() => new EditMyopiaState();
}

class EditMyopiaState extends State<EditMyopia> {
  final sphRow = new EditSphWidget();
  final cylRow = new EditCylWidget();
  final axRow = new EditAxWidget();
  final addRow = new EditAddWidget();
  final pdRpw = new EditPdWidget();

  void _nextAction() {
    sphRow.cacheData();
    cylRow.cacheData();
    axRow.cacheData();
    addRow.cacheData();
    pdRpw.cacheData();

    GlobalData.getInstance().cacheCreateTime();
    GlobalData.getInstance().cacheFinalResult();
    GlobalData.getInstance().saveVisionAllData();

    if (widget.fromResult) {
      Navigator.pop(context, RESULT_TO_EDIT);
    } else if (widget.fromHome) {
      Navigator.pushReplacement(
        context,
        new MaterialPageRoute(
          builder: (context) => new ResultMyopia(
            fromWelcome: widget.fromWelcome,
          ),
        ),
        result: HOME_TO_EDIT,
      );
    } else {
      Navigator.pushReplacement(
        context,
        new MaterialPageRoute(
          builder: (context) => new ResultMyopia(
                fromWelcome: widget.fromWelcome,
              ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: _buildContent(),
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
    } else {
      Navigator.pop(context);
    }
    return new Future.value(false);
  }

  Widget _buildContent() {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(S.of(context).vision_status_title),
        backgroundColor: COLOR_MAIN_GREEN,
        automaticallyImplyLeading: true,
      ),
      body: new ListView(
        children: <Widget>[
          new Column(
            children: <Widget>[
              sphRow,
              cylRow,
              axRow,
              addRow,
            ],
          ),
          new Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: new Container(
                  height: 20,
                  alignment: Alignment.centerLeft,
                  child: new Text(
                    //'Additional',
                    S.of(context).vision_additional,
                    textAlign: TextAlign.center,
                    style: new TextStyle(
                      color: COLOR_RESULT_HEADER,
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ),
              new Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Color(0x7F979797), width: 0.5)),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          pdRpw,
          Padding(
            padding: const EdgeInsets.only(left: 48, top: 16, right: 48),
            child: new FlatButton(
              color: COLOR_MAIN_GREEN,
              onPressed: () {
                _nextAction();
              },
              child: Text(
                //'NEXT',
                S.of(context).vision_next,
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
            ),
          ),
          new Container(
            child: Padding(
              padding: const EdgeInsets.only(top: 0, bottom: 16),
              child: new FlatButton(
                onPressed: () {},
                child: Text(
                  //'How can I get these information?',
                  S.of(context).vision_get_info,
                  textAlign: TextAlign.left,
                  style: new TextStyle(
                    fontSize: 14,
                    color: Color(0xFF21D48F),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
