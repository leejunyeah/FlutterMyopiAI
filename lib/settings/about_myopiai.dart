import 'package:flutter/material.dart';
import 'package:flutter_myopia_ai/generated/i18n.dart';
import 'package:flutter_myopia_ai/util/myopia_const.dart';

class AboutMyopiAI extends StatefulWidget {
  @override
  _AboutMyopiAIState createState() => new _AboutMyopiAIState();
}

class _AboutMyopiAIState extends State<AboutMyopiAI> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(S.of(context).settings_about_myopiai),
        backgroundColor: COLOR_MAIN_GREEN,
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
//            Text(
//              S.of(context).settings_about_myopiai,
//              style: TextStyle(
//                fontSize: 14,
//                fontWeight: FontWeight.bold,
//                color: COLOR_RESULT_TITLE,
//              ),
//            ),
//            SizedBox(
//              height: 30,
//            ),
            Text(
              S.of(context).about_myopiai_1,
              style: TextStyle(
                fontSize: 12,
                color: COLOR_RESULT_TITLE,
              ),
            ),
            Text(
              S.of(context).about_myopiai_2,
              style: TextStyle(
                fontSize: 12,
                color: COLOR_RESULT_TITLE,
              ),
            ),
            Text(
              S.of(context).about_myopiai_3,
              style: TextStyle(
                fontSize: 12,
                color: COLOR_RESULT_TITLE,
              ),
            ),
            Text(
              S.of(context).about_myopiai_4,
              style: TextStyle(
                fontSize: 12,
                color: COLOR_RESULT_TITLE,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              padding: EdgeInsets.only(left: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '(1). ',
                    style: TextStyle(
                      fontSize: 10,
                      color: COLOR_RESULT_HEADER,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      S.of(context).about_myopiai_mark_1,
                      style: TextStyle(
                        fontSize: 10,
                        color: COLOR_RESULT_HEADER,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '(2). ',
                    style: TextStyle(
                      fontSize: 10,
                      color: COLOR_RESULT_HEADER,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      S.of(context).about_myopiai_mark_2,
                      style: TextStyle(
                        fontSize: 10,
                        color: COLOR_RESULT_HEADER,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '(3). ',
                    style: TextStyle(
                      fontSize: 10,
                      color: COLOR_RESULT_HEADER,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      S.of(context).about_myopiai_mark_3,
                      style: TextStyle(
                        fontSize: 10,
                        color: COLOR_RESULT_HEADER,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
