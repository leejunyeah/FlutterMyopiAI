import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_myopia_ai/chart/activity_chart.dart';
import 'package:flutter_myopia_ai/data/activity_item.dart';
import 'package:flutter_myopia_ai/data/gl_data.dart';
import 'package:flutter_myopia_ai/generated/i18n.dart';
import 'package:flutter_myopia_ai/home/edit_myopia.dart';
import 'package:flutter_myopia_ai/home/result_myopia.dart';
import 'package:flutter_myopia_ai/settings/about_us.dart';
import 'package:flutter_myopia_ai/settings/dialog_content_20_intro.dart';
import 'package:flutter_myopia_ai/util/myopia_const.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

class Settings extends StatefulWidget {
  @override
  SettingsState createState() => new SettingsState();
}

class SettingsState extends State<Settings> {
  bool _is20Checked = true;
  bool _isDialogShowing = false;

  static const settingsPlugin =
      const MethodChannel('com.myopia.flutter_myopia_ai/settings');

  @override
  void initState() {
    _is20Checked = gl202020 == null ? true : gl202020;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(S.of(context).settings_title),
        backgroundColor: COLOR_MAIN_GREEN,
      ),
      body: _buildSettingsList(),
    );
  }

  Widget _buildSettingsList() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          _myVisionStatus(),
          _buildDivider(),
          _myopiaLevel(),
          _buildDivider(),
          _statistic(),
          _buildDivider(),
          _202020(),
          _buildDivider(),
          _feedback(),
          _buildDivider(),
          _about(),
          _buildDivider(),
          _rate(),
        ],
      ),
    );
  }

  Widget _myVisionStatus() {
    return InkWell(
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16),
        height: 68,
        child: Row(
          children: <Widget>[
            SvgPicture.asset(
              'assets/ic_assignment.svg',
            ),
            SizedBox(
              width: 16,
            ),
            _buildItemTitle(S.of(context).settings_vision_status),
          ],
        ),
      ),
      onTap: () => _handleMyopia(),
    );
  }

  Widget _myopiaLevel() {
    return InkWell(
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16),
        height: 68,
        child: Row(
          children: <Widget>[
            SvgPicture.asset(
              'assets/ic_search_myopia_level.svg',
            ),
            SizedBox(
              width: 16,
            ),
            _buildItemTitle(S.of(context).settings_myopia_level),
          ],
        ),
      ),
      onTap: () => Navigator.push(
        context,
        new MaterialPageRoute(builder: (context) => new EditMyopia()),
      ),
    );
  }

  Widget _statistic() {
    return InkWell(
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16),
        height: 68,
        child: Row(
          children: <Widget>[
            SvgPicture.asset(
              'assets/ic_statistic.svg',
            ),
            SizedBox(
              width: 16,
            ),
            _buildItemTitle(S.of(context).settings_statistics),
          ],
        ),
      ),
      onTap: () => Navigator.push(
        context,
        new MaterialPageRoute(
          builder: (context) => new ActivityChartWidget(
            itemType: ActivityItem.TYPE_NONE,
          ),
        ),
      ),
    );
  }

  Widget _202020() {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16),
      height: 68,
      child: Row(
        children: <Widget>[
          SvgPicture.asset(
            'assets/ic_20_20_20.svg',
          ),
          SizedBox(
            width: 16,
          ),
          _buildItemTitle('20/20/20'),
          InkWell(
            child: Container(
              padding: EdgeInsets.only(left: 8, right: 8),
              child: Icon(
                Icons.info,
                size: 18,
                color: Color(0x0F000000),
              ),
            ),
            onTap: () => _show20Dialog(),
          ),
          Expanded(
            flex: 1,
            child: Container(),
          ),
          Container(
            width: 1,
            height: 52,
            color: Color(0x0F000000),
          ),
          InkWell(
            child: Container(
              padding: EdgeInsets.only(left: 16),
              child: Switch(
                value: _is20Checked,
                onChanged: (boolValue) => _on20Changed(),
                activeColor: COLOR_MAIN_GREEN,
              ),
            ),
            onTap: _on20Changed,
          ),
        ],
      ),
    );
  }

  void _on20Changed() {
    bool checked = !_is20Checked;
    GlobalData.getInstance().save202020(checked);
    setState(() {
      this._is20Checked = checked;
    });
  }

  Widget _feedback() {
    return InkWell(
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16),
        height: 68,
        child: Row(
          children: <Widget>[
            SvgPicture.asset(
              'assets/ic_feedback.svg',
            ),
            SizedBox(
              width: 16,
            ),
            _buildItemTitle(S.of(context).settings_feedback),
          ],
        ),
      ),
      onTap: _handleFeedback,
    );
  }

  Widget _about() {
    return InkWell(
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16),
        height: 68,
        child: Row(
          children: <Widget>[
            SvgPicture.asset(
              'assets/ic_about_us.svg',
            ),
            SizedBox(
              width: 16,
            ),
            _buildItemTitle(S.of(context).settings_about_us),
          ],
        ),
      ),
      onTap: () => Navigator.push(
        context,
        new MaterialPageRoute(builder: (context) => new AboutUs()),
      ),
    );
  }

  Widget _rate() {
    return InkWell(
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16),
        height: 68,
        child: Row(
          children: <Widget>[
            SvgPicture.asset(
              'assets/ic_rate_us.svg',
            ),
            SizedBox(
              width: 16,
            ),
            _buildItemTitle(S.of(context).settings_rate_us),
          ],
        ),
      ),
      onTap: () {
        _rateUs();
      },
    );
  }

  Widget _buildItemTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        color: COLOR_RESULT_TITLE,
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      padding: EdgeInsets.only(left: 16, top: 0, right: 16, bottom: 0),
      child: Divider(
        color: Color(0x1E000000),
      ),
    );
  }

  _handleMyopia() {
    if (glResult == null) {
      Navigator.push(
        context,
        new MaterialPageRoute(builder: (context) => new EditMyopia()),
      );
    } else {
      Navigator.push(
        context,
        new MaterialPageRoute(builder: (context) => new ResultMyopia()),
      );
    }
  }

  _show20Dialog() {
    if (!_isDialogShowing) {
      _isDialogShowing = true;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return DialogContent(
            onClosed: () => _isDialogShowing = false,
          );
        },
      );
    }
  }

  _handleFeedback() async {
    if (Platform.isIOS) {
      await settingsPlugin.invokeMethod('feedback');
    } else {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String version = packageInfo.version;
      String mail =
          'mailto:myopiai.tech@gmail.com?subject=[Version: $version]MyopiAI Feedback';
      launch(mail);
    }
  }

  Future<Null> _rateUs() async {
    await settingsPlugin.invokeMethod('rateUs');
  }
}
