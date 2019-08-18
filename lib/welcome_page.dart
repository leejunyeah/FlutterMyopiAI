import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_myopia_ai/data/gl_data.dart';
import 'package:flutter_myopia_ai/home/edit_myopia.dart';
import 'package:flutter_myopia_ai/main_page.dart';
import 'package:flutter_myopia_ai/util/myopia_const.dart';

import 'generated/i18n.dart';


class WelcomePage extends StatefulWidget {
  @override
  WelcomePageState createState() => new WelcomePageState();
}

class WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 153,
          ),
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            child: icLogo,
          ),
          SizedBox(
            height: 62,
          ),
          Text(
//            'Welcome to MyopiAI',
            S.of(context).welcome_title,
            style: TextStyle(
              fontSize: 24,
              color: Color(0xff212121),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: 22,
          ),
          Container(
            padding: EdgeInsets.only(left: 34, right: 34),
            child: Text(
              //'Please complete the following steps to input your spectacles (glasses) or contact lens prescription. We will give you some personalised eye care advice after.',
              S.of(context).welcome_content,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xdd000000),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(
            height: 98,
          ),
          _buildGoButton(),
          SizedBox(
            height: 24,
          ),
          new Container(
            child: Padding(
              padding: const EdgeInsets.only(top: 0, bottom: 16),
              child: new FlatButton(
                onPressed: _doLater,
                child: Text(
                  //'DO IT LATER',
                  S.of(context).welcome_later,
                  textAlign: TextAlign.left,
                  style: new TextStyle(
                    fontSize: 14,
                    color: Color(0xFF21D48F),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoButton() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          SizedBox(
            width: 48,
          ),
          Expanded(
            flex: 1,
            child: FlatButton(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              color: COLOR_MAIN_GREEN,
              highlightColor: Colors.green[700],
              colorBrightness: Brightness.dark,
              splashColor: Colors.grey,
              child: Text(
                //"GO",
                S.of(context).welcome_go,
                style: TextStyle(fontSize: 18, color: Color(0xFFFFFFFF)),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0)),
              onPressed: _goAction,
            ),
          ),
          SizedBox(
            width: 48,
          ),
        ],
      ),
    );
  }

  _goAction() {
    GlobalData.getInstance().saveFirstStart();
    Navigator.pop(context);
    Navigator.push(
      context,
      new MaterialPageRoute(
          builder: (context) => new EditMyopia(fromWelcome: true)),
    );
  }

  _doLater() {
    GlobalData.getInstance().saveFirstStart();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext context) => MainPage()),
      (Route<dynamic> route) => false,
    );
  }
}
