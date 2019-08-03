import 'package:flutter/material.dart';
import 'package:flutter_myopia_ai/util/myopia_const.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:intro_slider/intro_slider.dart';

class EyeExercise extends StatefulWidget {
  @override
  _EyeExerciseState createState() => new _EyeExerciseState();
}

class _EyeExerciseState extends State<EyeExercise> {
  List<Slide> slides = new List();
  @override
  void initState() {
    _buildSlides();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Eye exercise"),
        backgroundColor: COLOR_MAIN_GREEN,
      ),
      body: IntroSlider(
        // List slides
        slides: this.slides,
        // Dot indicator
        colorDot: Color(0x3313D077),
        colorActiveDot: COLOR_MAIN_GREEN,
        sizeDot: 6.0,

        // Skip button
        renderSkipBtn: Container(),
        colorSkipBtn: Colors.transparent,
        highlightColorSkipBtn: Colors.transparent,

        // Next button
        renderNextBtn: Container(),

        // Done button
        renderDoneBtn: Container(),
        onDonePress: () => {},
        colorDoneBtn: Colors.transparent,
        highlightColorDoneBtn: Colors.transparent,
      ),
    );
  }

  _buildSlides() {
    slides.add(
      new Slide(
        marginTitle: EdgeInsets.only(top: 0, bottom: 0),
        centerWidget:
            _buildExerciseStep(eyeExercise1, '1）knead Tianying(Ashi)point.'),
        directionColorBegin: Alignment.topLeft,
        directionColorEnd: Alignment.bottomRight,
        backgroundColor: Colors.white,
        onCenterItemPress: () {},
      ),
    );
    slides.add(
      new Slide(
        marginTitle: EdgeInsets.only(top: 0, bottom: 0),
        centerWidget: _buildExerciseStep(
            eyeExercise2, '2）Press and squeeze Jingming(BL1).'),
        directionColorBegin: Alignment.topLeft,
        directionColorEnd: Alignment.bottomRight,
        backgroundColor: Colors.white,
        onCenterItemPress: () {},
      ),
    );
    slides.add(
      new Slide(
        marginTitle: EdgeInsets.only(top: 0, bottom: 0),
        centerWidget:
            _buildExerciseStep(eyeExercise3, '3）Press and Knead Sibai(ST2).'),
        directionColorBegin: Alignment.topLeft,
        directionColorEnd: Alignment.bottomRight,
        backgroundColor: Colors.white,
        onCenterItemPress: () {},
      ),
    );
    slides.add(
      new Slide(
        marginTitle: EdgeInsets.only(top: 0, bottom: 0),
        centerWidget: _buildExerciseStep(eyeExercise4,
            '4）Press Taiyang(Ex-HN5)and scrape Cuanzhu(BL2), Yuyao(EX-HN4), Sizhukong(TE23), Tongziliao(GB1), Chengqi(ST1).'),
        directionColorBegin: Alignment.topLeft,
        directionColorEnd: Alignment.bottomRight,
        backgroundColor: Colors.white,
        onCenterItemPress: () {},
      ),
    );
  }

  Widget _buildExerciseStep(Widget svgPicture, String text) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            padding: EdgeInsets.only(left: 40, top: 50, right: 40),
            child: Text(
              text,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 16,
                color: Color(0xff191919),
              ),
            ),
          ),
          SizedBox(
            height: 57,
          ),
          svgPicture,
        ],
      ),
    );
  }
}
