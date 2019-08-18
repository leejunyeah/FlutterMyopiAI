import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_myopia_ai/generated/i18n.dart';
import 'package:flutter_myopia_ai/util/myopia_const.dart';
import 'package:package_info/package_info.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => new _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  static const settingsPlugin =
      const MethodChannel('com.myopia.flutter_myopia_ai/settings');

  String _version;

  @override
  void initState() {
    _setVersion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(S.of(context).settings_about_us),
        backgroundColor: COLOR_MAIN_GREEN,
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: 98,
        ),
        Container(
          width: double.infinity,
          alignment: Alignment.center,
          child: icLogo,
        ),
        SizedBox(
          height: 9,
        ),
        _buildName(),
        SizedBox(
          height: 7,
        ),
        _buildVersion(),
        SizedBox(
          height: 20,
        ),
        _buildUpdate(),
        _buildDivider(),
        _buildTeam(),
        _buildDivider(),
      ],
    );
  }

  Widget _buildName() {
    return Text(
      S.of(context).app_name,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF000000),
      ),
    );
  }

  _setVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _version = packageInfo.version;
    setState(() {});
  }

  Widget _buildVersion() {
    return Text(
      _version == null
          ? '${S.of(context).settings_version}'
          : '${S.of(context).settings_version} $_version',
      style: TextStyle(
        fontSize: 12,
        color: Color(0x7F000000),
      ),
    );
  }

  Widget _buildUpdate() {
    return InkWell(
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16),
        height: 68,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _buildItemTitle(S.of(context).settings_update_check),
            Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF868686),
              size: 14,
            ),
          ],
        ),
      ),
      onTap: () {
        _checkUpdate();
      },
    );
  }

  Widget _buildTeam() {
    return InkWell(
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16),
        height: 68,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _buildItemTitle(S.of(context).settings_team_page),
            Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF868686),
              size: 14,
            ),
          ],
        ),
      ),
      onTap: () => {},
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

  Future<Null> _checkUpdate() async {
    await settingsPlugin.invokeMethod('checkUpdate');
  }
}
