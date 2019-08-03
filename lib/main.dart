import 'package:flutter/material.dart';

import 'package:flutter_myopia_ai/app.dart';
import 'package:flutter_myopia_ai/data/gl_data.dart';

void main() {
  GlobalData.getInstance().loadAsync().then((_) {
    GlobalData.getInstance().initAllVisionData();
    runApp(MyopiaAi());
  });
}
