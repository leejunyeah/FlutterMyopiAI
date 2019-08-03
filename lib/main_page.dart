import 'package:flutter/material.dart';

import 'package:flutter_myopia_ai/home/home.dart';
import 'package:flutter_myopia_ai/activity/activity.dart';
import 'package:flutter_myopia_ai/settings/settings.dart';
import 'package:flutter_myopia_ai/util/myopia_const.dart';
import 'package:flutter_myopia_ai/fonts/my_flutter_app_icons.dart';

import 'generated/i18n.dart';


class MainPage extends StatefulWidget {
  @override
  MainPageState createState() => new MainPageState();
}

class MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  TabController controller;

  @override
  void initState() {
    controller = new TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new TabBarView(
        controller: controller,
        children: [
          new Home(),
          new Activity(),
          new Settings(),
        ],
      ),
      bottomNavigationBar: new Material(
        color: Colors.white,
        elevation: 4,
        child: new TabBar(
          unselectedLabelColor: Color(0x4C212121),
          labelColor: COLOR_MAIN_GREEN,
          indicatorColor: COLOR_MAIN_GREEN,
          controller: controller,
          tabs: [
            new Tab(
              //text: "Home",
              text: S.of(context).home_title,
              icon: new Icon(
                Icons.home,
              ),
            ),
            new Tab(
              //text: "Activity",
              text: S.of(context).activity_title,
              icon: new Icon(
                MyIcons.ic_activity,
              ),
            ),
            new Tab(
              //text: "Settings",
              text: S.of(context).settings_title,
              icon: new Icon(
                Icons.settings,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
