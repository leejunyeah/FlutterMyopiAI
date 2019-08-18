import 'dart:math';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/services.dart';
import 'package:flutter_myopia_ai/util/myopia_const.dart';

import '../generated/i18n.dart';

class LightConditionWidget extends StatefulWidget {
  final List<charts.Series<LightConditionChart, int>> seriesList;
  LightConditionWidget({this.seriesList});

  @override
  _LightConditionWidgetState createState() => new _LightConditionWidgetState();
}

class _LightConditionWidgetState extends State<LightConditionWidget> {
  static const recordPlugin =
      const MethodChannel('com.myopia.flutter_myopia_ai/record');

  bool _isConditionChecked = true;

  final bool animate = true;

  _LightConditionWidgetState();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildWidget();
  }

  Widget _buildWidget() {
    int currentLux = widget.seriesList.last.data.last.lightValue;
    return Column(
      children: <Widget>[
        InkWell(
          child: Padding(
            padding: EdgeInsets.only(left: 32, top: 6, right: 32, bottom: 6),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: Text(
                        //'Light condition',
                        S.of(context).activity_light_condition,
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF000000),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Switch(
                      activeColor: COLOR_MAIN_GREEN,
                      value: this._isConditionChecked,
                      onChanged: (boolValue) => _onCheckedChanged(),
                    ),
                  ],
                ),
                Container(
                  child: Text(
                    //'Warning when brightness is not good enough for eye activities.',
                    S.of(context).activity_light_des,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0x7F000000),
                    ),
                  ),
                ),
              ],
            ),
          ),
          onTap: _onCheckedChanged,
        ),
        Offstage(
          offstage: !this._isConditionChecked,
          child: Container(
            height: 100,
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Card(
              color: Colors.white,
              elevation: 4,
              shape: CARD_SHAPE,
              child: Container(
                padding: EdgeInsets.only(left: 6),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: -15,
                      top: 30,
                      child: Transform.rotate(
                        child: Text(
                          //'Brightness',
                          S.of(context).activity_light_brightness,
                          style:
                              TextStyle(fontSize: 12, color: Color(0x33000000)),
                        ),
                        angle: pi / 2.0,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10, bottom: 8),
                      child: _buildLineChart(),
                    ),
                    Positioned(
                      right: 20,
                      top: 70,
                      child: Text(
                        //'Time',
                        S.of(context).activity_light_time,
                        style:
                            TextStyle(fontSize: 12, color: Color(0x33000000)),
                      ),
                    ),
                    Positioned(
                      left: 35,
                      top: 70,
                      child: Text(
                        //'Time',
                        '${S.of(context).recording_current_light}$currentLux',
                        style: TextStyle(
                            fontSize: 10,
                            color: currentLux < 20
                                ? INDOOR_COLOR_5
                                : Color(0x33000000)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _onCheckedChanged() {
    _changeCanNotifyLight(!this._isConditionChecked);
    setState(() {
      this._isConditionChecked = !this._isConditionChecked;
    });
  }

  Future<Null> _changeCanNotifyLight(bool canNotify) async {
    Map<String, String> map = {"canNotifyLight": canNotify ? "true" : "false"};
    await recordPlugin.invokeMethod('setCanNotifyLight', map);
  }

  Widget _buildLineChart() {
    return new charts.LineChart(
      widget.seriesList,
      animate: animate,
      primaryMeasureAxis: new charts.NumericAxisSpec(
          renderSpec: new charts.NoneRenderSpec(), showAxisLine: true),
      domainAxis: new charts.NumericAxisSpec(
        // Make sure that we draw the domain axis line.
        showAxisLine: true,
        // But don't draw anything else.
        renderSpec: new charts.NoneRenderSpec(),
      ),
//        behaviors: [
//          new charts.RangeAnnotation([
//            new charts.LineAnnotationSegment(
//                50, charts.RangeAnnotationAxisType.measure,
//                color: charts.Color(r: 0x00, g: 0x00, b: 0x00, a: 0x19)),
//          ]),
//        ]
    );
  }
}

class LightConditionChart {
  final int time;
  final int lightValue;

  LightConditionChart(this.time, this.lightValue);
}
