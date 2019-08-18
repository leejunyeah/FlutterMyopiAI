import 'package:flutter/material.dart';
import 'package:flutter_myopia_ai/data/SortActivityItem.dart';
import 'package:flutter_myopia_ai/data/activity_item.dart';
import 'package:flutter_myopia_ai/data/custom_type.dart';
import 'package:flutter_myopia_ai/generated/i18n.dart';
import 'package:flutter_myopia_ai/home/home_progress_painter.dart';
import 'package:flutter_myopia_ai/util/myopia_const.dart';

class HomeTotalProgress extends StatefulWidget {
  final List<SortActivityItem> dataList;
  final List<Color> indoorColorList;
  final List<Color> outdoorColorList;
  final Map<int, CustomType> customList;

  HomeTotalProgress(
      {this.dataList,
      this.indoorColorList,
      this.outdoorColorList,
      this.customList});

  @override
  _HomeTotalProgressState createState() => new _HomeTotalProgressState();
}

class _HomeTotalProgressState extends State<HomeTotalProgress> {
  int _indoor = 0;
  int _outdoor = 0;

  bool _isShowMore;

  HomeProgressPainter _indoorProgressPainter;
  HomeProgressPainter _outdoorProgressPainter;

  @override
  void initState() {
    _isShowMore = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _getActivityList();
    _indoorProgressPainter = HomeProgressPainter(
        sortedDataList: widget.dataList,
        colorList: widget.indoorColorList,
        indoorOutdoorType: ActivityItem.TYPE_INDOOR);
    _outdoorProgressPainter = HomeProgressPainter(
        sortedDataList: widget.dataList,
        colorList: widget.outdoorColorList,
        indoorOutdoorType: ActivityItem.TYPE_OUTDOOR);
    return _buildProgress();
  }

  Widget _buildProgress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 10,
        ),
        Container(
          height: 20,
          child: CustomPaint(
            size: Size(MediaQuery.of(context).size.width, 10),
            painter: HomeProgressPainter(
                sortedDataList: widget.dataList,
                indoorOutdoorType: 0,
                forTotal: true),
          ),
        ),
        _buildNotes(),
        SizedBox(
          height: 10,
        ),
        InkWell(
          child: Container(
            padding: EdgeInsets.only(top: 5, bottom: 5),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  _isShowMore
                      ? S.of(context).home_hide
                      : S.of(context).home_show_more,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: COLOR_RESULT_HEADER,
                    fontSize: 13,
                  ),
                ),
                SizedBox(
                  width: 14,
                ),
                _isShowMore
                    ? Icon(
                        Icons.keyboard_arrow_up,
                        color: Color(0xFF979797),
                      )
                    : Icon(
                        Icons.keyboard_arrow_down,
                        color: Color(0xFF979797),
                      )
              ],
            ),
          ),
          onTap: () {
            setState(() {
              _isShowMore = !_isShowMore;
            });
          },
        ),
        Offstage(
          offstage: !_isShowMore,
          child: Container(
            height: 22,
            alignment: Alignment.center,
            child: Divider(
              height: 1,
              color: Color(0x0F000000),
            ),
          ),
        ),
        Offstage(
          offstage: !_isShowMore,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(
                S.of(context).home_indoor_time,
                textAlign: TextAlign.start,
                style: new TextStyle(
                  color: COLOR_RESULT_DETAIL,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buildProgressTag(ActivityItem.TYPE_INDOOR),
              ),
            ],
          ),
        ),
        Offstage(
          offstage: !_isShowMore,
          child: Container(
            height: 30,
            alignment: Alignment.center,
            child: Divider(
              height: 1,
              color: Color(0x0F000000),
            ),
          ),
        ),
        Offstage(
          offstage: !_isShowMore,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(
                S.of(context).home_outdoor_time,
                textAlign: TextAlign.start,
                style: new TextStyle(
                  color: COLOR_RESULT_DETAIL,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buildProgressTag(ActivityItem.TYPE_OUTDOOR),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildProgressTag(int indoorOutdoorType) {
    HomeProgressPainter progressPainter;
    if (indoorOutdoorType == ActivityItem.TYPE_INDOOR) {
      progressPainter = _indoorProgressPainter;
    } else {
      progressPainter = _outdoorProgressPainter;
    }
    List<ProgressItem> dataList = progressPainter.getDataList();
    if (dataList == null) return null;
    List<Widget> children = [];
    children.add(
      Container(
        height: 50,
        child: CustomPaint(
          size: Size(MediaQuery.of(context).size.width, 10),
          painter: progressPainter,
        ),
      ),
    );
    List<_DetailNode> noteList = [];
//    int index = 0;
    for (ProgressItem progressItem in dataList) {
//      index++;
//      if (index > MAX_DETAIL_COUNT) break;
      String typeString =
          getShortActivityTypeString(context, progressItem.type);
      if (progressItem.type & ActivityItem.TYPE_CUSTOM != 0) {
        if (widget.customList.containsKey(progressItem.customType)) {
          typeString = widget.customList[progressItem.customType].typeText;
        }
      } else if (progressItem.type & ActivityItem.TYPE_OTHER_TOTAL != 0) {
        typeString = S.of(context).activity_others;
      }
      String time = _parseTargetTimeToString(progressItem.value);
      String text = '$typeString $time';
      _DetailNode _detailNode = new _DetailNode();
      _detailNode.text = text;
      _detailNode.progressItem = progressItem;
      noteList.add(_detailNode);
    }

    if (noteList.isEmpty) {
      children.add(_buildNoneNote());
    } else {
      children.add(_buildDetailNotes(noteList, indoorOutdoorType));
    }
    return children;
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
          S.of(context).home_activity_none,
          style: TextStyle(
            fontSize: 14,
            color: Color(0x7F000000),
          ),
        ),
      ],
    );
  }

  Widget _buildNotes() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                S.of(context).activity_indoor,
                style: TextStyle(
                  fontSize: 12,
                  color: getActivityColor(ActivityItem.TYPE_INDOOR),
                ),
              ),
              Text(
                _parseTargetTimeToString(_indoor),
                style: TextStyle(
                  fontSize: 12,
                  color: getActivityColor(ActivityItem.TYPE_INDOOR),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                S.of(context).activity_outdoor,
                style: TextStyle(
                  fontSize: 12,
                  color: getActivityColor(ActivityItem.TYPE_OUTDOOR),
                ),
              ),
              Text(
                _parseTargetTimeToString(_outdoor),
                style: TextStyle(
                  fontSize: 12,
                  color: getActivityColor(ActivityItem.TYPE_OUTDOOR),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailNotes(List<_DetailNode> noteList, int indoorOutdoorType) {
    return Wrap(
      spacing: 8.0, // 主轴(水平)方向间距
      runSpacing: 4.0, // 纵轴（垂直）方向间距
      children: getWidgetList(noteList, indoorOutdoorType),
    );
  }

  List<Widget> getWidgetList(
      List<_DetailNode> noteList, int indoorOutdoorType) {
    List<Widget> widgetList = [];
    int index = 0;
    for (_DetailNode node in noteList) {
      Color color;
      if (indoorOutdoorType == ActivityItem.TYPE_INDOOR) {
        if (widget.indoorColorList != null &&
            index < widget.indoorColorList.length) {
          color = widget.indoorColorList[index];
        } else {
          color = COLOR_NONE;
        }
      } else {
        if (widget.outdoorColorList != null &&
            index < widget.outdoorColorList.length) {
          color = widget.outdoorColorList[index];
        } else {
          color = COLOR_NONE;
        }
      }
      widgetList.add(_getItemContainer(node, color));
      index++;
    }
    return widgetList;
  }

  Widget _getItemContainer(_DetailNode _detailNode, Color color) {
    return Container(
      alignment: Alignment.centerLeft,
      width: 140,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Icon(
            Icons.brightness_1,
            color: color,
            size: 8,
          ),
          SizedBox(
            width: 8,
          ),
          Text(
            _detailNode.text,
            style: TextStyle(
              fontSize: 14,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  String _parseTargetTimeToString(int time) {
    if (time <= 0) {
      return '0${S.of(context).time_min}';
    }
    String targetTime = "";
    int hour = (time ~/ (60 * 60)).toInt();
    int min = ((time - hour * 60 * 60) ~/ 60).toInt();
    String hourString = hour > 0 ? '$hour' + S.of(context).time_h : '';
    String minString = min > 0
        ? (min > 1
            ? '$min' + S.of(context).time_mins
            : '$min' + S.of(context).time_min)
        : '';
    targetTime =
        hourString.length > 0 ? hourString + ' ' + minString : minString;
    return targetTime;
  }

  _getActivityList() {
    _getActualTimeAndPercent();
  }

  _getActualTimeAndPercent() {
    int indoorTime = 0;
    int outdoorTime = 0;

    _indoor = 0;
    _outdoor = 0;

    if (widget.dataList != null) {
      for (SortActivityItem item in widget.dataList) {
        if (item.type & ActivityItem.TYPE_INDOOR != 0) {
          indoorTime += ((item.totalTime ~/ 60) * 60);
        } else if (item.type & ActivityItem.TYPE_OUTDOOR != 0) {
          outdoorTime += ((item.totalTime ~/ 60) * 60);
        }
      }
    }

    indoorTime = indoorTime < 60 ? 0 : indoorTime;
    outdoorTime = outdoorTime < 60 ? 0 : outdoorTime;

    setState(() {
      _indoor = indoorTime;
      _outdoor = outdoorTime;
    });
  }
}

class _DetailNode {
  String text;
  ProgressItem progressItem;
}
