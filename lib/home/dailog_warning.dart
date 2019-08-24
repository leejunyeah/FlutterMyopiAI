import 'package:flutter/material.dart';
import 'package:flutter_myopia_ai/generated/i18n.dart';
import 'package:flutter_myopia_ai/util/myopia_const.dart';

class DialogWarning extends StatefulWidget {

  final String content;
  final Function onConfirm;

  DialogWarning({this.content, this.onConfirm});

  @override
  State<StatefulWidget> createState() => _DialogWarning();

}

class _DialogWarning extends State<DialogWarning> {

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency, //设置透明的效果
      child: Center(
        child: SizedBox(
          width: 280,
          height: 190,
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
                      widget.content,
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
                              S.of(context).ok,
                              style:
                              TextStyle(color: COLOR_MAIN_GREEN, fontSize: 18),
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
