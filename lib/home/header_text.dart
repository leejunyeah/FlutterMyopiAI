import 'package:flutter/material.dart';
import 'package:flutter_myopia_ai/util/myopia_const.dart';

import '../generated/i18n.dart';

Widget buildTextHeader(var text) {
  var header = new Text(
    text,
    textAlign: TextAlign.center,
    style: new TextStyle(
        color: COLOR_RESULT_TITLE, fontSize: 16.0, fontWeight: FontWeight.bold),
  );
  return header;
}

Widget buildLeftHeader(BuildContext context) {
  var header = new Text(
//    "LEFT",
    S.of(context).left,
    textAlign: TextAlign.center,
    style: new TextStyle(
        color: Color(0x4F000000), fontSize: 14.0, fontWeight: FontWeight.bold),
  );
  return header;
}

Widget buildRightHeader(BuildContext context) {
  var header = new Text(
//    "RIGHT",
    S.of(context).right,
    textAlign: TextAlign.center,
    style: new TextStyle(
        color: Color(0x4F000000), fontSize: 14.0, fontWeight: FontWeight.bold),
  );
  return header;
}
