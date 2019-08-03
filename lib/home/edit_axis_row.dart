import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_myopia_ai/util/myopia_const.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:flutter_myopia_ai/home/header_text.dart';
import 'package:flutter_myopia_ai/data/gl_data.dart';

import '../generated/i18n.dart';

class EditAxWidget extends StatefulWidget {
  EditAxWidget({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _EditAxWidgetState createState() => new _EditAxWidgetState();

  void cacheData() {
    glAxRight = rightCounter == null ? 0 : rightCounter;
    glAxLeft = leftCounter == null ? 0 : leftCounter;
  }
}

int leftCounter = 0;
int rightCounter = 0;

class _EditAxWidgetState extends State<EditAxWidget> {
  _EditAxWidgetState() {
    _initData();
  }

  void _initData() {
    leftCounter = glAxLeft;
    rightCounter = glAxRight;
  }

  @override
  Widget build(BuildContext context) {
    return buildAxRow();
  }

  void _leftChanged(str) {
    if (str == null || str == '') return;
    int temp = int.parse(str);
    if (temp > 180) {
      setState(() {
        leftCounter = 180;
      });
      Fluttertoast.showToast(
        msg: S.of(context).ax_warning,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
      );
    } else {
      leftCounter = temp;
    }
  }

  void _rightChanged(str) {
    if (str == null || str == '') return;
    int temp = int.parse(str);
    if (temp > 180) {
      setState(() {
        rightCounter = 180;
      });
      Fluttertoast.showToast(
        msg: S.of(context).ax_warning,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
      );
    } else {
      rightCounter = temp;
    }
  }

  Widget buildAxRow() {
    var axRow = Padding(
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
                      color: COLOR_TV,
                      size: 8,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    buildTextHeader(S.of(context).vision_ax),
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
                  color: Color(0x4C4F7CEC),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                children: <Widget>[
                  new Expanded(
                    flex: 1,
                    child: new Column(
                      children: <Widget>[
                        buildLeftHeader(context),
                        new TextField(
                          autofocus: false,
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: false),
                          style: STYLE_EDIT_ITEM,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '0',
                          ),
                          controller: TextEditingController.fromValue(
                            TextEditingValue(
                              // 设置内容
                              text: leftCounter == null ? '' : '$leftCounter',
                            ),
                          ),
                          onChanged: _leftChanged,
                          inputFormatters: [
                            WhitelistingTextInputFormatter.digitsOnly
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: new Column(
                      children: <Widget>[
                        buildRightHeader(context),
                        new TextField(
                          autofocus: false,
                          style: STYLE_EDIT_ITEM,
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: false),
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '0',
                          ),
                          controller: TextEditingController.fromValue(
                            TextEditingValue(
                              // 设置内容
                              text: rightCounter == null ? '' : '$rightCounter',
                            ),
                          ),
                          onChanged: _rightChanged,
                          inputFormatters: [
                            WhitelistingTextInputFormatter.digitsOnly
                          ],
                        ),
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
    return axRow;
  }
}
