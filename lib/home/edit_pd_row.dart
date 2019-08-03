import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_myopia_ai/data/gl_data.dart';
import 'package:flutter_myopia_ai/util/myopia_const.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:flutter_myopia_ai/home/header_text.dart';
import '../generated/i18n.dart';

class EditPdWidget extends StatefulWidget {
  EditPdWidget({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _EditPdWidgetState createState() => new _EditPdWidgetState();

  void cacheData() {
    glPd = pdValue == null ? 0 : pdValue;
  }
}

int pdValue;

class _EditPdWidgetState extends State<EditPdWidget> {
  _EditPdWidgetState() {
    _initData();
  }

  void _initData() {
    pdValue = glPd;
  }

  @override
  Widget build(BuildContext context) {
    return buildPdRow();
  }

  void _pdValueChanged(str) {
    int temp = int.parse(str);
    if (temp > 100) {
      setState(() {
        pdValue = 100;
      });
      Fluttertoast.showToast(
        msg: S.of(context).pd_warning,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
      );
    } else {
      pdValue = temp;
    }
  }

  Widget buildPdRow() {
    var pdRow = Padding(
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
                      color: COLOR_MAIN_GREEN,
                      size: 8,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    buildTextHeader(
                      //'Pupillary distance(PD)',
                      S.of(context).vision_pd,
                    ),
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 70,
                    child: new TextField(
                      autofocus: false,
                      style: STYLE_EDIT_ITEM,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: false),
                      textAlign: TextAlign.end,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '0',
                      ),
                      controller: TextEditingController.fromValue(
                        TextEditingValue(
                          // 设置内容
                          text: pdValue == null ? '0.00' : '$pdValue',
                        ),
                      ),
                      onChanged: _pdValueChanged,
                      inputFormatters: [
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  new Text(
                    'mm',
                    textAlign: TextAlign.start,
                    style: new TextStyle(
                      color: COLOR_RESULT_HEADER,
                      fontSize: 14.0,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
    return pdRow;
  }
}
