import 'package:flutter/material.dart';

import 'package:flutter_myopia_ai/data/gl_data.dart';
import 'package:flutter_myopia_ai/util/myopia_const.dart';

import '../generated/i18n.dart';

class ResultTips extends StatefulWidget {
  @override
  _ResultTipsState createState() => new _ResultTipsState();
}

class _ResultTipsState extends State<ResultTips>
    with SingleTickerProviderStateMixin {
  List<_Choice> tabs = [];
  TabController mTabController;
  int mCurrentPosition = 0;
  String result = '';

  @override
  Widget build(BuildContext context) {
    _setTab();
    return new Column(
      children: <Widget>[
        new TabBar(
          indicatorSize: TabBarIndicatorSize.label,
          indicatorColor: COLOR_MAIN_GREEN,
          labelColor: COLOR_MAIN_GREEN,
          unselectedLabelColor: COLOR_RESULT_HEADER,
          labelStyle: TextStyle(
            color: COLOR_RESULT_HEADER,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          tabs: tabs.map((_Choice choice) {
            return new Tab(
              text: choice.title,
            );
          }).toList(),
          controller: mTabController,
        ),
        Container(
          height: 400,
          child: new TabBarView(
            children: tabs.map((_Choice choice) {
              return new Padding(
                padding: const EdgeInsets.all(15.0),
                child: new Container(
                  child: new Text(
                    choice.des,
                    style: TextStyle(
                      color: COLOR_RESULT_HEADER,
                      fontSize: 14,
                    ),
                  ),
                ),
              );
            }).toList(),
            controller: mTabController,
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    mTabController = new TabController(vsync: this, length: 3);
    //判断TabBar是否切换
    mTabController.addListener(() {
      if (mTabController.indexIsChanging) {
        setState(() {
          mCurrentPosition = mTabController.index;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    mTabController.dispose();
  }

  _setTab() {
    tabs.clear();
    if (glResult == LEVEL_MILD) {
      tabs.add(_Choice(title: S.of(context).result_des_diagnosis, des: S.of(context).mild_des_diagnosis, position: 0));
      tabs.add(_Choice(title: S.of(context).result_des_tips, des: S.of(context).mild_des_tips, position: 1));
      tabs.add(_Choice(title: S.of(context).result_des_ref, des: S.of(context).mild_des_references, position: 2));
      result = S.of(context).result_mild;
    } else if (glResult == LEVEL_MODERATE) {
      tabs.add(_Choice(title: S.of(context).result_des_diagnosis, des: S.of(context).moderate_des_diagnosis, position: 0));
      tabs.add(_Choice(title: S.of(context).result_des_tips, des: S.of(context).moderate_des_tips, position: 1));
      tabs.add(_Choice(title: S.of(context).result_des_ref, des: S.of(context).moderate_des_references, position: 2));
      result = S.of(context).result_moderate;
    } else if (glResult == LEVEL_HIGH) {
      tabs.add(_Choice(title: S.of(context).result_des_diagnosis, des: S.of(context).high_des_diagnosis, position: 0));
      tabs.add(_Choice(title: S.of(context).result_des_tips, des: S.of(context).high_des_tips, position: 1));
      tabs.add(_Choice(title: S.of(context).result_des_ref, des: S.of(context).high_des_references, position: 2));
      result = S.of(context).result_high;
    } else {
      tabs.add(_Choice(title: S.of(context).result_des_diagnosis, des: S.of(context).normal_des_diagnosis, position: 0));
      tabs.add(_Choice(title: S.of(context).result_des_tips, des: S.of(context).normal_des_tips, position: 1));
      tabs.add(_Choice(title: S.of(context).result_des_ref, des: S.of(context).normal_des_references, position: 2));
      result = S.of(context).result_normal;
    }
    setState(() {

    });
  }
}

class _Choice {
  const _Choice({this.title, this.des, this.icon, this.position});
  final String title;
  final String des;
  final int position;
  final IconData icon;
}
