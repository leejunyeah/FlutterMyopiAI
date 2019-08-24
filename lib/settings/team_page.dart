import 'package:flutter/material.dart';
import 'package:flutter_myopia_ai/generated/i18n.dart';
import 'package:flutter_myopia_ai/util/myopia_const.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TeamPage extends StatefulWidget {
  @override
  _TeamPageState createState() => new _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(S.of(context).team_page_title),
        backgroundColor: COLOR_MAIN_GREEN,
      ),
      body: _buildContent(),
      backgroundColor: Color(0xFFF3F3F3),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(height: 32),
          _buildHeader(),
          SizedBox(height: 22),
          _buildTopMan(),
          _buildDeveloper(),
          _buildLei(),
          _buildMeng(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text(
            S.of(context).app_name,
            style: TextStyle(
              color: Color(0xFF524E49),
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            S.of(context).team_page_our_team,
            style: TextStyle(
              color: Color(0xFF524E49),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopMan() {
    return Container(
      padding: EdgeInsets.only(left: 6, right: 6, bottom: 6),
      child: Card(
        elevation: 1,
        shape: CARD_SHAPE,
        child: Container(
          padding: EdgeInsets.all(8),
          child: Row(
            children: <Widget>[
              new ClipOval(
                child: Image.asset(
                  'images/top_man_pic.jpeg',
                  height: 82,
                  width: 82,
                  fit: BoxFit.fitWidth,
                ),
              ),
              SizedBox(
                width: 16,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Connor',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF000000),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    S.of(context).founder_title,
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0x7F000000),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeveloper() {
    return Container(
      padding: EdgeInsets.only(left: 6, right: 6, bottom: 6),
      child: Card(
        elevation: 1,
        shape: CARD_SHAPE,
        child: Container(
          padding: EdgeInsets.all(8),
          child: Row(
            children: <Widget>[
              new ClipOval(
                child: Image.asset(
                  'images/developer_pic.jpeg',
                  height: 82,
                  width: 82,
                  fit: BoxFit.fitWidth,
                ),
              ),
              SizedBox(
                width: 16,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Yeah',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF000000),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    S.of(context).developer_title,
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0x7F000000),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLei() {
    return Container(
      padding: EdgeInsets.only(left: 6, right: 6, bottom: 6),
      child: Card(
        elevation: 1,
        shape: CARD_SHAPE,
        child: Container(
          padding: EdgeInsets.all(8),
          child: Row(
            children: <Widget>[
              SvgPicture.asset(
                'assets/about_us_lei.svg',
                height: 82,
                width: 82,
                fit: BoxFit.fitWidth,
              ),
              SizedBox(
                width: 16,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Lei',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF000000),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    S.of(context).lei_title,
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0x7F000000),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMeng() {
    return Container(
      padding: EdgeInsets.only(left: 6, right: 6, bottom: 6),
      child: Card(
        elevation: 1,
        shape: CARD_SHAPE,
        child: Container(
          padding: EdgeInsets.all(8),
          child: Row(
            children: <Widget>[
              SvgPicture.asset(
                'assets/about_us_meng.svg',
                height: 82,
                width: 82,
                fit: BoxFit.fitWidth,
              ),
              SizedBox(
                width: 16,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Meng',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF000000),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    S.of(context).meng_title,
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0x7F000000),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
