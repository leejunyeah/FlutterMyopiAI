import 'package:flutter/material.dart';
import 'package:flutter_myopia_ai/chart/activity_chart.dart';
import 'package:flutter_myopia_ai/data/activity_item.dart';
import 'package:flutter_myopia_ai/data/gl_data.dart';
import 'package:flutter_myopia_ai/home/edit_myopia.dart';
import 'package:flutter_myopia_ai/home/result_myopia.dart';
import 'package:flutter_myopia_ai/util/myopia_const.dart';

class Settings extends StatefulWidget {
  @override
  SettingsState createState() => new SettingsState();
}

class SettingsState extends State<Settings> {
  bool _is20Checked = true;

  @override
  void initState() {
    _is20Checked = gl202020 == null ? true : gl202020;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Settings"),
        backgroundColor: COLOR_MAIN_GREEN,
      ),
      body: _buildSettingsList(),
    );
  }

  Widget _buildSettingsList() {
    return ListView(
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
    );
  }

  Widget _myVisionStatus() {
    return InkWell(
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16),
        height: 68,
        child: Row(
          children: <Widget>[
            icAssignment,
            SizedBox(
              width: 16,
            ),
            _buildItemTitle('My vision status'),
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
            icSearchMyLevel,
            SizedBox(
              width: 16,
            ),
            _buildItemTitle('Search myopia level'),
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
            icStatistic,
            SizedBox(
              width: 16,
            ),
            _buildItemTitle('Statistic'),
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
    return InkWell(
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16),
        height: 68,
        child: Row(
          children: <Widget>[
            ic202020,
            SizedBox(
              width: 16,
            ),
            Expanded(
              flex: 1,
              child: _buildItemTitle('20/20/20'),
            ),
            Switch(
              value: _is20Checked,
              onChanged: (boolValue) => _on20Changed(),
              activeColor: COLOR_MAIN_GREEN,
            ),
          ],
        ),
      ),
      onTap: _on20Changed,
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
            icFeedback,
            SizedBox(
              width: 16,
            ),
            _buildItemTitle('Feedback'),
          ],
        ),
      ),
      onTap: () => {},
    );
  }

  Widget _about() {
    return InkWell(
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16),
        height: 68,
        child: Row(
          children: <Widget>[
            icAboutUs,
            SizedBox(
              width: 16,
            ),
            _buildItemTitle('About us'),
          ],
        ),
      ),
      onTap: () => {},
    );
  }

  Widget _rate() {
    return InkWell(
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16),
        height: 68,
        child: Row(
          children: <Widget>[
            icRateUs,
            SizedBox(
              width: 16,
            ),
            _buildItemTitle('Rate us'),
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
}
