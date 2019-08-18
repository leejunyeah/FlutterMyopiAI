import 'package:flutter/material.dart';
import 'package:flutter_myopia_ai/exercise/eye_exercise.dart';
import 'package:flutter_myopia_ai/generated/i18n.dart';
import 'package:flutter_myopia_ai/util/myopia_const.dart';

class StartEyeExercise extends StatefulWidget {
  @override
  _StartEyeExerciseState createState() => new _StartEyeExerciseState();
}

class _StartEyeExerciseState extends State<StartEyeExercise> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(S.of(context).eye_exercise),
        backgroundColor: COLOR_MAIN_GREEN,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 60,
            ),
            Text(
              S.of(context).eye_exercise_start_title,
              style: TextStyle(
                fontSize: 18,
                color: COLOR_RESULT_TITLE,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Image.asset('images/eye_exercise_face_1.png'),
            SizedBox(
              height: 30,
            ),
            Image.asset('images/eye_exercise_face_2.png'),
            SizedBox(
              height: 50,
            ),
            Container(
              padding: EdgeInsets.only(left: 27, right: 27),
              child: Text(
                S.of(context).eye_exercise_start_summary,
                style: TextStyle(
                  fontSize: 16,
                  color: COLOR_RESULT_TITLE,
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            _buildStartButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildStartButton() {
    return Padding(
      padding: EdgeInsets.only(bottom: 40),
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
                S.of(context).start,
                style: TextStyle(fontSize: 18, color: Color(0xFFFFFFFF)),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0)),
              onPressed: () => Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => new EyeExercise()),
              ),
            ),
          ),
          SizedBox(
            width: 48,
          ),
        ],
      ),
    );
  }
}
