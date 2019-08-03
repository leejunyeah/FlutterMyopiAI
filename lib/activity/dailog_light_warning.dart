import 'package:flutter/material.dart';
import 'package:flutter_myopia_ai/util/myopia_const.dart';

import '../generated/i18n.dart';

class DialogLightWarning extends StatefulWidget {

  final Function onConfirm;

  DialogLightWarning({this.onConfirm});

  @override
  State<StatefulWidget> createState() => _DialogLightWarning();

}

class _DialogLightWarning extends State<DialogLightWarning> {

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency, //设置透明的效果
      child: Center(
        child: SizedBox(
          width: 280,
          height: 170,
          child: Card(
            elevation: 12,
            shape: CARD_SHAPE,
            child: Container(
              padding: EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 10),
              child: Column(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    alignment: Alignment.topLeft,
                    child: Text(
                      //'Warning!',
                      S.of(context).warning_title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF000000),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    width: double.infinity,
                    alignment: Alignment.topCenter,
                    child: Text(
                      //'Find more light! Don\'t strain your eyes!',
                      S.of(context).activity_light_warning,
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0x89000000),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: FlatButton(
                            onPressed: () => _handleConfirm(),
                            child: Text(
                              //'OK',
                              S.of(context).ok,
                              style:
                              TextStyle(color: Color(0xE2F82E47), fontSize: 18),
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _handleConfirm() {
    widget.onConfirm();
    Navigator.pop(context);
  }
}
