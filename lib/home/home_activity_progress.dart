import 'package:flutter/material.dart';
import 'package:flutter_myopia_ai/data/activity_item.dart';
import 'package:flutter_myopia_ai/generated/i18n.dart';
import 'package:flutter_myopia_ai/util/myopia_const.dart';

class ActivityProgress extends StatefulWidget {
  final List<ActivityItem> activityList;
  final int type;

  ActivityProgress({this.activityList, this.type});

  @override
  _ActivityProgressState createState() => new _ActivityProgressState();
}

class _ActivityProgressState extends State<ActivityProgress> {
  int _totalFlex = 10;

  int _reading = 0;
  int _computer = 0;
  int _tv = 0;
  int _phone = 0;
  int _sports = 0;
  int _hike = 0;
  int _swim = 0;
  int _other = 0;

  List<String> notes = [];

  int _readingFlex = 0;
  int _computerFlex = 0;
  int _tvFlex = 0;
  int _phoneFlex = 0;
  int _otherFlex = 0;
  int _sportsFlex = 0;
  int _hikeFlex = 0;
  int _swimFlex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _getActivityList();
    if ((_reading + _computer + _tv + _phone + _other <= 0 &&
            widget.type & ActivityItem.TYPE_INDOOR != 0) ||
        (_sports + _hike + _swim + _other <= 0 &&
            widget.type & ActivityItem.TYPE_OUTDOOR != 0)) {
      return _buildNone();
    } else {
      return _buildProgress();
    }
  }

  Widget _buildNone() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Text(
              (widget.type & ActivityItem.TYPE_INDOOR != 0)
                  ? S.of(context).home_indoor_time
                  : S.of(context).home_outdoor_time,
              textAlign: TextAlign.start,
              style: new TextStyle(
                color: COLOR_RESULT_DETAIL,
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 30,
        ),
        Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                height: 10,
                decoration: new BoxDecoration(
                  color: COLOR_NONE, // 底色
                  borderRadius:
                      new BorderRadius.all(Radius.circular(20)), // 也可控件一边圆角大小
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: Column(
            children: <Widget>[
              Container(
                width: 1,
                height: 10,
                color: COLOR_NONE, // 底色
              ),
              Text(
                '0${S.of(context).time_h}',
                style: TextStyle(color: Color(0xFFDADDDA), fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Text(
              (widget.type & ActivityItem.TYPE_INDOOR != 0)
                  ? S.of(context).home_indoor_time
                  : S.of(context).home_outdoor_time,
              textAlign: TextAlign.start,
              style: new TextStyle(
                color: COLOR_RESULT_DETAIL,
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
          ],
        ),
        SizedBox(height: 12,),
        Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.center,
                height: 120,
                child: (widget.type & ActivityItem.TYPE_INDOOR != 0)
                    ? Stack(
                        children: <Widget>[
                          Offstage(
                            offstage: _other == 0,
                            child: _buildOther(),
                          ),
                          Offstage(
                            offstage: _phone == 0,
                            child: _buildPhone(),
                          ),
                          Offstage(
                            offstage: _tv == 0,
                            child: _buildTv(),
                          ),
                          Offstage(
                            offstage: _computer == 0,
                            child: _buildComputer(),
                          ),
                          Offstage(
                            offstage: _reading == 0,
                            child: _buildReading(),
                          ),
                        ],
                      )
                    : Stack(
                        children: <Widget>[
                          Offstage(
                            offstage: _other == 0,
                            child: _buildOther(),
                          ),
                          Offstage(
                            offstage: _swim == 0,
                            child: _buildSwim(),
                          ),
                          Offstage(
                            offstage: _hike == 0,
                            child: _buildHike(),
                          ),
                          Offstage(
                            offstage: _sports == 0,
                            child: _buildSports(),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
//        SizedBox(
//          height: 2,
//        ),
//        _buildNotes(),
      ],
    );
  }

  Widget _buildReading() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: _readingFlex,
          child: Column(
            children: <Widget>[
              Container(
                height: 22,
              ),
              _buildProgressBar(ActivityItem.TYPE_READING),
              Container(
                padding: EdgeInsets.only(left: 4),
                alignment: Alignment.centerLeft,
                height: 22,
                child: Offstage(
                  offstage: _reading == 0,
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: 1,
                        height: 8,
                        color:
                            getActivityColor(ActivityItem.TYPE_READING), // 底色
                      ),
                      Text(
                        S.of(context).activity_reading +
                            _parseTargetTimeToString(_reading),
                        style: TextStyle(
                            color: getActivityColor(ActivityItem.TYPE_READING),
                            fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: (_totalFlex - _readingFlex),
          child: Container(),
        ),
      ],
    );
  }

  Widget _buildComputer() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: _computerFlex,
          child: Column(
//            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                alignment: Alignment.bottomRight,
                height: 22,
                child: Offstage(
                  offstage: _computer == 0,
                  child: Column(
                    children: <Widget>[
                      Text(
                        _parseTargetTimeToString(_computer),
                        style: TextStyle(
                            color: getActivityColor(ActivityItem.TYPE_COMPUTER),
                            fontSize: 12),
                      ),
                      Container(
                        width: 1,
                        height: 8,
                        color:
                            getActivityColor(ActivityItem.TYPE_COMPUTER), // 底色
                      ),
                    ],
                  ),
                ),
              ),
              _buildProgressBar(ActivityItem.TYPE_COMPUTER),
              Container(
                height: 22,
              ),
            ],
          ),
        ),
        Expanded(
          flex: (_totalFlex - _computerFlex),
          child: Container(),
        ),
      ],
    );
  }

  Widget _buildTv() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: _tvFlex,
          child: Column(
            children: <Widget>[
              Container(
                height: 22,
              ),
              _buildProgressBar(ActivityItem.TYPE_TV),
              Container(
                alignment: Alignment.centerRight,
                height: 22,
                child: Offstage(
                  offstage: _tv == 0,
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: 1,
                        height: 8,
                        color: getActivityColor(ActivityItem.TYPE_TV), // 底色
                      ),
                      Text(
                        _parseTargetTimeToString(_tv),
                        style: TextStyle(
                            color: getActivityColor(ActivityItem.TYPE_TV),
                            fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: (_totalFlex - _tvFlex),
          child: Container(),
        ),
      ],
    );
  }

  Widget _buildPhone() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: _phoneFlex,
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.centerRight,
                height: 22,
                child: Offstage(
                  offstage: _phone == 0,
                  child: Column(
                    children: <Widget>[
                      Text(
                        _parseTargetTimeToString(_phone),
                        style: TextStyle(
                            color: getActivityColor(ActivityItem.TYPE_PHONE),
                            fontSize: 12),
                      ),
                      Container(
                        width: 1,
                        height: 8,
                        color: getActivityColor(ActivityItem.TYPE_PHONE), // 底色
                      ),
                    ],
                  ),
                ),
              ),
              _buildProgressBar(ActivityItem.TYPE_PHONE),
              Container(
                height: 22,
              ),
            ],
          ),
        ),
        Expanded(
          flex: (_totalFlex - _phoneFlex),
          child: Container(),
        ),
      ],
    );
  }

  Widget _buildOther() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: _otherFlex,
          child: Column(
            children: <Widget>[
              Container(
                height: 40,
                alignment: Alignment.centerRight,
                child: Column(
                  children: <Widget>[
                    Text(
                      '${S.of(context).activity_others} ${_parseTargetTimeToString(_other)}',
                      style: TextStyle(
                          color: getActivityColor(ActivityItem.TYPE_CUSTOM),
                          fontSize: 12),
                    ),
                    Container(
                      width: 1,
                      height: 8,
                      color: getActivityColor(ActivityItem.TYPE_CUSTOM), // 底色
                    ),
                  ],
                ),
              ),
              _buildProgressBar(ActivityItem.TYPE_CUSTOM),
              Container(
                height: 40,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSwim() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: _swimFlex,
          child: Column(
            children: <Widget>[
              Container(
                height: 40,
              ),
              _buildProgressBar(ActivityItem.TYPE_SWIM),
              Container(
                alignment: Alignment.centerRight,
                height: 40,
                child: Offstage(
                  offstage: _swim == 0,
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: 1,
                        height: 8,
                        color: getActivityColor(ActivityItem.TYPE_SWIM), // 底色
                      ),
                      Text(
                        '${S.of(context).activity_swim} ${_parseTargetTimeToString(_swim)}',
                        style: TextStyle(
                            color: getActivityColor(ActivityItem.TYPE_SWIM),
                            fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: (_totalFlex - _swimFlex),
          child: Container(),
        ),
      ],
    );
  }

  Widget _buildHike() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: _hikeFlex,
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.centerRight,
                height: 40,
                child: Offstage(
                  offstage: _hike == 0,
                  child: Column(
                    children: <Widget>[
                      Text(
                        '${S.of(context).activity_hike} ${_parseTargetTimeToString(_hike)}',
                        style: TextStyle(
                            color: getActivityColor(ActivityItem.TYPE_HIKE),
                            fontSize: 12),
                      ),
                      Container(
                        width: 1,
                        height: 8,
                        color: getActivityColor(ActivityItem.TYPE_HIKE), // 底色
                      ),
                    ],
                  ),
                ),
              ),
              _buildProgressBar(ActivityItem.TYPE_HIKE),
              Container(
                height: 40,
              ),
            ],
          ),
        ),
        Expanded(
          flex: (_totalFlex - _hikeFlex),
          child: Container(),
        ),
      ],
    );
  }

  Widget _buildSports() {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              flex: _sportsFlex,
              child: Column(
                children: <Widget>[
                  Container(
                    height: 40,
                  ),
                  _buildProgressBar(ActivityItem.TYPE_SPORTS),
                ],
              ),
            ),
            Expanded(
              flex: (_totalFlex - _sportsFlex),
              child: Container(
                height: 54,
              ),
            ),
          ],
        ),
        Container(
          alignment: Alignment.centerLeft,
          child: Offstage(
            offstage: _sports == 0,
            child: Column(
              children: <Widget>[
                Container(
                  width: 1,
                  height: 8,
                  color: getActivityColor(ActivityItem.TYPE_SPORTS), // 底色
                ),
                Text(
                  '${S.of(context).activity_sports} ${_parseTargetTimeToString(_sports)}',
                  style: TextStyle(
                      color: getActivityColor(ActivityItem.TYPE_SPORTS),
                      fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ],
    );

  }

  Widget _buildNoneNote() {
    return Row(
      children: <Widget>[
        Icon(
          Icons.brightness_1,
          color: COLOR_NONE,
          size: 8,
        ),
        SizedBox(
          width: 8,
        ),
        Text(
          'nota activity',
          style: TextStyle(
            fontSize: 14,
            color: Color(0x7F000000),
          ),
        ),
      ],
    );
  }

  Widget _buildNotes() {
    return Wrap(
      spacing: 8.0, // 主轴(水平)方向间距
      runSpacing: 4.0, // 纵轴（垂直）方向间距
      children: getWidgetList(),
    );
  }

  List<Widget> getWidgetList() {
    return notes.map((item) => _getItemContainer(item)).toList();
  }

  Widget _getItemContainer(String item) {
    return Container(
      alignment: Alignment.centerLeft,
      width: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Icon(
            Icons.brightness_1,
            color: getColor(item),
            size: 8,
          ),
          SizedBox(
            width: 8,
          ),
          Text(
            item,
            style: TextStyle(
              fontSize: 14,
              color: Color(0x7F000000),
            ),
          ),
        ],
      ),
    );
  }

//  void _initFlex() {
//    _reading = 1;
//    _computer = 4;
//    _tv = 1;
//    _phone = 2;
//    _other = 2;
//
//    _readingFlex = total - (_computer + _tv + _phone + _other);
//    _computerFlex = total - (_tv + _phone + _other);
//    _tvFlex = total - (_phone + _other);
//    _phoneFlex = total - _other;
//    _otherFlex = _other;
//  }

  String _parseTargetTimeToString(int time) {
    String targetTime = "";
    int hour = (time ~/ (60 * 60)).toInt();
    int min = ((time - hour * 60 * 60) ~/ 60).toInt();
    String hourString = hour > 0 ? '${hour}h' : '';
    String minString = min > 0 ? (min > 1 ? '${min}mins' : '${min}min') : '';
    targetTime =
        hourString.length > 0 ? hourString + ' ' + minString : minString;
    return targetTime;
  }

  void _initNotes() {
    notes.clear();
    if (_reading > 0) {
      notes.add(READING);
    }
    if (_computer > 0) {
      notes.add(COMPUTER);
    }
    if (_tv > 0) {
      notes.add(TV);
    }
    if (_phone > 0) {
      notes.add(PHONE);
    }
    if (_other > 0) {
      notes.add(OTHER);
    }
  }

//  Widget _buildProgressBar(String item) {
//    return Container(
//      padding: EdgeInsets.all(2),
//      decoration: new BoxDecoration(
//        color: Color(0xFFFFFFFF), // 底色
//        borderRadius: new BorderRadius.all(Radius.circular(8)), // 也可控件一边圆角大小
//      ),
//      child: Container(
//        height: 10,
//        decoration: new BoxDecoration(
//          color: getColor(item), // 底色
//          borderRadius: new BorderRadius.all(Radius.circular(8)), // 也可控件一边圆角大小
//        ),
//      ),
//    );
//  }

  Widget _buildProgressBar(int type) {
    return Container(
      padding: EdgeInsets.all(2),
      decoration: new BoxDecoration(
        color: Color(0xFFFFFFFF), // 底色
        borderRadius: new BorderRadius.all(Radius.circular(8)), // 也可控件一边圆角大小
      ),
      child: Container(
        height: 10,
        decoration: new BoxDecoration(
          color: getActivityColor(type), // 底色
          borderRadius: new BorderRadius.all(Radius.circular(8)), // 也可控件一边圆角大小
        ),
      ),
    );
  }

  _getActivityList() async {
    _getActualTimeAndPercent();
//    _initNotes();
  }

  _getActualTimeAndPercent() {
    int readingTime = 0;
    int computerTime = 0;
    int tvTime = 0;
    int phoneTime = 0;
    int otherTime = 0;
    int sportsTime = 0;
    int hikeTime = 0;
    int swimTime = 0;

    _reading = 0;
    _computer = 0;
    _tv = 0;
    _phone = 0;
    _other = 0;
    _sports = 0;
    _hike = 0;
    _swim = 0;

    if (widget.activityList != null) {
      for (ActivityItem item in widget.activityList) {
        if (item.type & widget.type == 0) continue;
        if (item.type & ActivityItem.TYPE_READING != 0) {
          readingTime += ((item.actual ~/ 60) * 60);
        } else if (item.type & ActivityItem.TYPE_TV != 0) {
          tvTime += ((item.actual ~/ 60) * 60);
        } else if (item.type & ActivityItem.TYPE_COMPUTER != 0) {
          computerTime += ((item.actual ~/ 60) * 60);
        } else if (item.type & ActivityItem.TYPE_PHONE != 0) {
          phoneTime += ((item.actual ~/ 60) * 60);
        } else if (item.type & ActivityItem.TYPE_CUSTOM != 0) {
          otherTime += ((item.actual ~/ 60) * 60);
        } else if (item.type & ActivityItem.TYPE_SPORTS != 0) {
          sportsTime += ((item.actual ~/ 60) * 60);
        } else if (item.type & ActivityItem.TYPE_HIKE != 0) {
          hikeTime += ((item.actual ~/ 60) * 60);
        } else if (item.type & ActivityItem.TYPE_SWIM != 0) {
          swimTime += ((item.actual ~/ 60) * 60);
        }
      }
    }

    // for indoor
    readingTime = 1200; //readingTime < 60 ? 0 : readingTime;
    computerTime = 1200; //computerTime < 60 ? 0 : computerTime;
    tvTime = 1200; //tvTime < 60 ? 0 : tvTime;
    phoneTime = 1200; //phoneTime < 60 ? 0 : phoneTime;
    // for outdoor
    sportsTime = 1200; //sportsTime < 60 ? 0 : sportsTime;
    hikeTime = 1200; //hikeTime < 60 ? 0 : hikeTime;
    swimTime = 1200; //swimTime < 60 ? 0 : swimTime;

    otherTime = 1200; //otherTime < 60 ? 0 : otherTime;

    if (widget.type == ActivityItem.TYPE_INDOOR) {
      int total = readingTime + tvTime + computerTime + phoneTime + otherTime;
      int rFlex = total <= 0 ? 0 : readingTime;
      int cFlex = total <= 0 ? 0 : readingTime + computerTime;
      int tvFlex = total <= 0 ? 0 : readingTime + computerTime + tvTime;
      int pFlex =
          total <= 0 ? 0 : readingTime + computerTime + tvTime + phoneTime;
      int oFlex = total <= 0
          ? 0
          : readingTime + computerTime + tvTime + phoneTime + otherTime;
      oFlex = oFlex < 0 ? 0 : oFlex;

      setState(() {
        _totalFlex = total;

        _reading = readingTime;
        _computer = computerTime;
        _tv = tvTime;
        _phone = phoneTime;
        _other = otherTime;

        _readingFlex = rFlex;
        _computerFlex = cFlex;
        _tvFlex = tvFlex;
        _phoneFlex = pFlex;
        _otherFlex = oFlex;
      });
    } else if (widget.type == ActivityItem.TYPE_OUTDOOR) {
      int total = sportsTime + hikeTime + swimTime + otherTime;
      int spFlex = total <= 0 ? 0 : sportsTime;
      int hFlex = total <= 0 ? 0 : sportsTime + hikeTime;
      int swFlex = total <= 0 ? 0 : sportsTime + hikeTime + swimTime;
      int oFlex = total <= 0 ? 0 : sportsTime + hikeTime + swimTime + otherTime;
      oFlex = oFlex < 0 ? 0 : oFlex;

      setState(() {
        _totalFlex = total;

        _sports = sportsTime;
        _hike = hikeTime;
        _swim = swimTime;
        _other = otherTime;

        _sportsFlex = spFlex;
        _hikeFlex = hFlex;
        _swimFlex = swFlex;
        _otherFlex = oFlex;
      });
    }
  }
}
