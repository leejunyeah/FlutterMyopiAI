import 'package:flutter/material.dart';
import 'package:flutter_myopia_ai/util/myopia_const.dart';

import '../generated/i18n.dart';

class DialogExitExercise extends StatefulWidget {

  final Function onCancel;
  final Function onConfirm;

  DialogExitExercise({this.onCancel, this.onConfirm});

  @override
  State<StatefulWidget> createState() => _DialogExitExercise();

}

class _DialogExitExercise extends State<DialogExitExercise> {

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency, //设置透明的效果
      child: Center(
        child: SizedBox(
          width: 280,
          height: 150,
          child: Card(
            elevation: 12,
            shape: CARD_SHAPE,
            child: Container(
              padding: EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 10),
              child: Column(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    alignment: Alignment.topCenter,
                    child: Text(
                      S.of(context).eye_exercise_exit_warning,
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
                          alignment: Alignment.centerRight,
                          child: FlatButton(
                            onPressed:() => _handleCancel(),
                            child: Text(
                              //'CANCEL',
                              S.of(context).cancel,
                              style:
                              TextStyle(color: RECORDING_DIALOG_BUTTON, fontSize: 14),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          width: double.infinity,
                          alignment: Alignment.centerRight,
                          child: FlatButton(
                            onPressed: () => _handleConfirm(),
                            child: Text(
                              //'OK',
                              S.of(context).ok,
                              style:
                              TextStyle(color: RECORDING_DIALOG_BUTTON, fontSize: 14),
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
  _handleCancel() {
    Navigator.pop(context);
    widget.onCancel();
  }

  _handleConfirm() {
    Navigator.pop(context);
    widget.onConfirm();
  }
}
