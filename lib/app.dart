import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_myopia_ai/data/gl_data.dart';

import 'package:flutter_myopia_ai/main_page.dart';
import 'package:flutter_myopia_ai/welcome_page.dart';

import 'generated/i18n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MyopiaAi extends StatefulWidget {

  @override
  MyopiaAiState createState() => new MyopiaAiState();
}

class MyopiaAiState extends State<MyopiaAi> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    glFirstStart
        ? SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark)
        : SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return new MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        S.delegate,
      ],
      localeResolutionCallback: (deviceLocale, supportedLocales) {
        GlobalData.getInstance().cacheLocale(deviceLocale.languageCode);
        return null;
      },
      supportedLocales: S.delegate.supportedLocales,
      home: new Scaffold(
        body: glFirstStart ? WelcomePage() : MainPage(),
      ),
    );
  }
}
