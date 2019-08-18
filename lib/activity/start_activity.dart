import 'package:flutter/material.dart';
import 'package:flutter_myopia_ai/data/custom_type.dart';

import 'package:flutter_myopia_ai/time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:flutter_myopia_ai/util/myopia_const.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'recording_activity.dart';
import 'package:flutter_myopia_ai/data/activity_item.dart';
import 'package:flutter_myopia_ai/data/database_helper.dart';

import '../generated/i18n.dart';

class StartActivity extends StatefulWidget {
  final bool forStartActivity;

  StartActivity({this.forStartActivity = true});

  @override
  _StartActivityState createState() => new _StartActivityState();
}

class _StartActivityState extends State<StartActivity> {
  bool _isTargetChecked = false;
  int _newActivityValue = ActivityItem.TYPE_READING;
  int _newTypeValue = ActivityItem.TYPE_INDOOR;
  String _newPickActivityString;
  String _newPickTypeString;
  String _newCustomTypeString;
  DateTime _targetTime;

  List<CustomType> _customList;
  List<_SelectActivity> _selectOutActivityList;
  List<_SelectActivity> _selectInActivityList;
  CustomType _historyCustomType;

  @override
  void initState() {
    _isTargetChecked = false;
    super.initState();
  }

  _setupPickString() {
    if (_newActivityValue == ActivityItem.TYPE_READING) {
      _newPickActivityString = S.of(context).activity_reading;
    } else if (_newActivityValue == ActivityItem.TYPE_COMPUTER) {
      _newPickActivityString = S.of(context).activity_front_computer;
    } else if (_newActivityValue == ActivityItem.TYPE_TV) {
      _newPickActivityString = S.of(context).activity_tv;
    } else if (_newActivityValue == ActivityItem.TYPE_PHONE) {
      _newPickActivityString = S.of(context).activity_using_phone;
    } else if (_newActivityValue == ActivityItem.TYPE_CUSTOM) {
      _newPickActivityString = S.of(context).activity_customise;
    } else if (_newActivityValue == ActivityItem.TYPE_SPORTS) {
      _newPickActivityString = S.of(context).activity_sports;
    } else if (_newActivityValue == ActivityItem.TYPE_HIKE) {
      _newPickActivityString = S.of(context).activity_hike;
    } else if (_newActivityValue == ActivityItem.TYPE_SWIM) {
      _newPickActivityString = S.of(context).activity_swim;
    }

    if (_newTypeValue == ActivityItem.TYPE_INDOOR) {
      _newPickTypeString = S.of(context).activity_indoor;
    } else if (_newTypeValue == ActivityItem.TYPE_OUTDOOR) {
      _newPickTypeString = S.of(context).activity_outdoor;
    }
  }

  @override
  Widget build(BuildContext context) {
    _setupPickString();
    _loadList();
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.forStartActivity
            ? S.of(context).start_new_activity
            : S.of(context).add_new_activity),
        backgroundColor: COLOR_MAIN_GREEN,
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 16, bottom: 16),
        child: ListView(
          children: <Widget>[
            _buildTypeTile(),
            Container(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Divider(
                height: 1,
                color: Color(0x0F000000),
              ),
            ),
            _buiLdSelectTile(),
            Container(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Divider(
                height: 1,
                color: Color(0x0F000000),
              ),
            ),
            Offstage(
              offstage: _newActivityValue != ActivityItem.TYPE_CUSTOM,
              child: Column(
                children: <Widget>[
                  _buildCustomEditTile(),
                  Container(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: Divider(
                      height: 1,
                      color: Color(0x0F000000),
                    ),
                  ),
                ],
              ),
            ),
            Offstage(
              offstage: !widget.forStartActivity,
              child: _buiLdTargetTile(),
            ),
            _buildTimePicker(),
            Offstage(
              offstage: _isTargetChecked || !widget.forStartActivity,
              child: SizedBox(
                height: 180,
              ),
            ),
            _buildStartButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeTile() {
    return InkWell(
      child: Container(
          height: 68,
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Text(
                  S.of(context).type_title,
                  style: TextStyle(fontSize: 16, color: COLOR_RESULT_TITLE),
                ),
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    Text(
                      '$_newPickTypeString',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ],
          )),
      onTap: _showTypePickerDialog,
    );
  }

  Widget _buiLdSelectTile() {
    return InkWell(
      child: Container(
          height: 68,
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Text(
                  //'Activity',
                  S.of(context).activity_title,
                  style: TextStyle(fontSize: 16, color: COLOR_RESULT_TITLE),
                ),
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    Text(
                      '$_newPickActivityString',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ],
          )),
      onTap: _newTypeValue == ActivityItem.TYPE_INDOOR
          ? _showIndoorActivityDialog
          : _showOutdoorActivityDialog,
    );
  }

  Widget _buildCustomEditTile() {
    return Container(
      height: 68,
      padding: EdgeInsets.only(left: 16, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: Text(
              S.of(context).activity_customise,
              style: TextStyle(fontSize: 16, color: COLOR_RESULT_TITLE),
            ),
          ),
          SizedBox(
            width: 50,
          ),
          Container(
//            height: 36,
            width: 150,
            child: TextField(
              style: TextStyle(
                color: Color(0xDD000000),
                fontSize: 16,
              ),
              maxLines: 1,
              textAlign: TextAlign.right,
              onChanged: _customTypeChanged,
              decoration: (_newCustomTypeString == null ||
                      _newCustomTypeString.trim().length == 0)
                  ? InputDecoration(
                      errorText: S.of(context).activity_empty_custom,
                    )
                  : InputDecoration(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buiLdTargetTile() {
    return InkWell(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: Text(
                //'Target',
                S.of(context).activity_target,
                style: TextStyle(fontSize: 16, color: COLOR_RESULT_TITLE),
              ),
            ),
            Switch(
              activeColor: COLOR_MAIN_GREEN,
              value: this._isTargetChecked,
              onChanged: (boolValue) => _onCheckedChanged(),
            ),
          ],
        ),
      ),
      onTap: _onCheckedChanged,
    );
  }

  void _onCheckedChanged() {
    setState(() {
      this._isTargetChecked = !_isTargetChecked;
    });
  }

  Widget _buildTimePicker() {
    return Offstage(
      offstage: !this._isTargetChecked && widget.forStartActivity,
      child: Container(
        padding: EdgeInsets.all(16),
        child: Card(
          shape: CARD_SHAPE,
          elevation: 4,
          child: Container(
            padding: EdgeInsets.only(bottom: 16),
            child: new TimePickerSpinner(
              alignment: Alignment.center,
              is24HourMode: true,
              normalTextStyle: TextStyle(
                  fontSize: 20,
                  color: COLOR_RESULT_HEADER,
                  fontWeight: FontWeight.bold),
              highlightedTextStyle: TextStyle(
                  fontSize: 24,
                  color: COLOR_RESULT_TITLE,
                  fontWeight: FontWeight.bold),
              spacing: 50,
              itemWidth: 60,
              itemHeight: 50,
              isForce2Digits: true,
              onTimeChange: (time) {
                _targetTime = time;
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStartButton() {
    return Padding(
      padding: EdgeInsets.only(bottom: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          SizedBox(
            width: 48,
          ),
          Expanded(
            flex: 1,
            child: FlatButton(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              color: COLOR_MAIN_GREEN,
              highlightColor: Colors.green[700],
              colorBrightness: Brightness.dark,
              splashColor: Colors.grey,
              child: Text(
                widget.forStartActivity
                    ? S.of(context).start
                    : S.of(context).activity_add_btn,
                style: TextStyle(fontSize: 18, color: Color(0xFFFFFFFF)),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0)),
              onPressed: widget.forStartActivity ? _startAction : _addAction,
            ),
          ),
          SizedBox(
            width: 48,
          ),
        ],
      ),
    );
  }

  void _startAction() async {
    if (_newActivityValue == ActivityItem.TYPE_CUSTOM) {
      if (_newCustomTypeString == null || _newCustomTypeString.trim() == '') {
        Fluttertoast.showToast(
          msg: S.of(context).activity_empty_custom,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
        );
        return;
      }
    }
    ActivityItem activityItem = await _saveStart();
    String title;
    if (activityItem.type & ActivityItem.TYPE_CUSTOM != 0) {
      title = _newCustomTypeString;
    } else {
      title = getActivityTypeString(context, activityItem.type);
    }
    int result = await Navigator.push(
      context,
      new MaterialPageRoute(
          builder: (context) => new RecordingActivity(
                activityItem: activityItem,
                title: title,
                isTargetChecked: _isTargetChecked,
              )),
    );
    if (result == HOME_TO_START_ACTIVITY) {
      Navigator.pop(context, HOME_TO_START_ACTIVITY);
    }
  }

  void _addAction() async {
    if (_newActivityValue == ActivityItem.TYPE_CUSTOM) {
      if (_newCustomTypeString == null || _newCustomTypeString.trim() == '') {
        Fluttertoast.showToast(
          msg: S.of(context).activity_empty_custom,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
        );
        return;
      }
    }
    await _saveStart();
    Navigator.pop(context, HOME_TO_START_ACTIVITY);
  }

  void _showIndoorActivityDialog() {
    List<Widget> children = [];
    children.add(
      Container(
        padding: EdgeInsets.all(24),
        child: Text(
          S.of(context).activity_title,
          style: TextStyle(fontSize: 20, color: Color(0xDD000000)),
        ),
      ),
    );
    if (_selectInActivityList != null) {
      _selectInActivityList.forEach(
            (element) {
          if (element.customType != null) {
            children.add(
              RadioListTile<int>(
                activeColor: COLOR_MAIN_GREEN,
                value: element.type,
                title: Text(
                  element.customType.typeText,
                  style: TextStyle(fontSize: 16, color: Color(0x89000000)),
                ),
                groupValue: _newActivityValue,
                onChanged: (value) {
                  setState(
                        () {
                      _newActivityValue = element.type;
                      _historyCustomType = element.customType;
                      _newPickActivityString = element.customType.typeText;
                    },
                  );
                  Navigator.of(context).pop();
                },
              ),
            );
          } else {
            children.add(
              RadioListTile<int>(
                activeColor: COLOR_MAIN_GREEN,
                value: element.type,
                title: Text(
                  element.text,
                  style: TextStyle(fontSize: 16, color: Color(0x89000000)),
                ),
                groupValue: _newActivityValue,
                onChanged: (value) {
                  setState(
                        () {
                      _newActivityValue = element.type;
                      _historyCustomType = null;
                      _newPickActivityString = element.text;
                    },
                  );
                  Navigator.of(context).pop();
                },
              ),
            );
          }
        },
      );
    }

    var dialog = new Dialog(
      shape: CARD_SHAPE,
      child: new SingleChildScrollView(
        child: ListBody(children: children),
      ),
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return dialog;
      },
    );
  }

  void _showOutdoorActivityDialog() {
    List<Widget> children = [];
    children.add(
      Container(
        padding: EdgeInsets.all(24),
        child: Text(
          S.of(context).activity_title,
          style: TextStyle(fontSize: 20, color: Color(0xDD000000)),
        ),
      ),
    );
    if (_selectOutActivityList != null) {
      _selectOutActivityList.forEach(
        (element) {
          if (element.customType != null) {
            children.add(
              RadioListTile<int>(
                activeColor: COLOR_MAIN_GREEN,
                value: element.type,
                title: Text(
                  element.customType.typeText,
                  style: TextStyle(fontSize: 16, color: Color(0x89000000)),
                ),
                groupValue: _newActivityValue,
                onChanged: (value) {
                  setState(
                    () {
                      _newActivityValue = element.type;
                      _historyCustomType = element.customType;
                      _newPickActivityString = element.customType.typeText;
                    },
                  );
                  Navigator.of(context).pop();
                },
              ),
            );
          } else {
            children.add(
              RadioListTile<int>(
                activeColor: COLOR_MAIN_GREEN,
                value: element.type,
                title: Text(
                  element.text,
                  style: TextStyle(fontSize: 16, color: Color(0x89000000)),
                ),
                groupValue: _newActivityValue,
                onChanged: (value) {
                  setState(
                    () {
                      _newActivityValue = element.type;
                      _historyCustomType = null;
                      _newPickActivityString = element.text;
                    },
                  );
                  Navigator.of(context).pop();
                },
              ),
            );
          }
        },
      );
    }
    var dialog = new Dialog(
      shape: CARD_SHAPE,
      child: new SingleChildScrollView(
        child: ListBody(children: children),
      ),
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return dialog;
      },
    );
  }

  void _showTypePickerDialog() {
    var dialog = new Dialog(
      shape: CARD_SHAPE,
      child: new SingleChildScrollView(
        child: ListBody(children: <Widget>[
          Container(
            padding: EdgeInsets.all(24),
            child: Text(
              S.of(context).type_title,
              style: TextStyle(fontSize: 20, color: Color(0xDD000000)),
            ),
          ),
          RadioListTile<int>(
              activeColor: COLOR_MAIN_GREEN,
              value: ActivityItem.TYPE_INDOOR,
              title: Text(
                S.of(context).activity_indoor,
                style: TextStyle(fontSize: 16, color: Color(0x89000000)),
              ),
              groupValue: _newTypeValue,
              onChanged: (value) {
                setState(() {
                  _newActivityValue = ActivityItem.TYPE_READING;
                  _newTypeValue = ActivityItem.TYPE_INDOOR;
                  _newPickTypeString = S.of(context).activity_indoor;
                  _newPickActivityString = S.of(context).activity_reading;
                });
                Navigator.of(context).pop();
              }),
          RadioListTile<int>(
              activeColor: COLOR_MAIN_GREEN,
              value: ActivityItem.TYPE_OUTDOOR,
              title: Text(
                S.of(context).activity_outdoor,
                style: TextStyle(fontSize: 16, color: Color(0x89000000)),
              ),
              groupValue: _newTypeValue,
              onChanged: (value) {
                setState(() {
                  _newActivityValue = ActivityItem.TYPE_SPORTS;
                  _newTypeValue = ActivityItem.TYPE_OUTDOOR;
                  _newPickTypeString = S.of(context).activity_outdoor;
                  _newPickActivityString = S.of(context).activity_sports;
                });
                Navigator.of(context).pop();
              }),
        ]),
      ),
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return dialog;
      },
    );
  }

  void _customTypeChanged(str) {
    _newCustomTypeString = str;
    setState(() {});
  }

  Future<ActivityItem> _saveStart() async {
    int count = await DatabaseHelper.internal().getCount();
    int customTypeId = 0;
    int itemType = _newTypeValue | _newActivityValue;
    if (_newActivityValue == ActivityItem.TYPE_CUSTOM) {
      CustomType findType =
          await DatabaseHelper.internal().getCustomType(_newCustomTypeString);
      if (findType == null) {
        customTypeId = await DatabaseHelper.internal().getCustomTypeCount();
        customTypeId++;
        CustomType customType = new CustomType(
          id: customTypeId,
          inOutDoor: _newTypeValue,
          typeText: _newCustomTypeString,
        );
        await DatabaseHelper.internal().insertCustomType(customType);
      } else {
        customTypeId = findType.id;
      }
    } else if (_historyCustomType != null) {
      itemType = _newTypeValue | ActivityItem.TYPE_CUSTOM;
      customTypeId = _historyCustomType.id;
    }

    int id = count + 1;
    ActivityItem activityItem = new ActivityItem(
      id: id,
      time: DateTime.now().millisecondsSinceEpoch,
      type: itemType,
      customType: customTypeId,
      target: (_targetTime == null || !_isTargetChecked)
          ? 0
          : _parseTargetTimeToSecond(),
      actual: widget.forStartActivity ? 0 : _parseTargetTimeToSecond(),
    );
    await DatabaseHelper.internal().insertActivity(activityItem);
    return activityItem;
  }

  int _parseTargetTimeToSecond() {
    int targetTime = 0;
    if (_isTargetChecked && _targetTime != null) {
      targetTime = _targetTime.minute * 60 + _targetTime.hour * 60 * 60;
    } else if (!widget.forStartActivity) {
      if (_targetTime == null) {
        targetTime = 30 * 60; // default is 20 mins
      } else {
        targetTime = _targetTime.minute * 60 + _targetTime.hour * 60 * 60;
      }
    }
    return targetTime;
  }

  _loadList() async {
    _customList = await DatabaseHelper.internal().selectCustomList();
    // For outdoor
    _selectOutActivityList = [];
    _selectOutActivityList.add(_SelectActivity(
      type: ActivityItem.TYPE_SPORTS,
      text: S.of(context).activity_sports,
    ));
    _selectOutActivityList.add(_SelectActivity(
      type: ActivityItem.TYPE_HIKE,
      text: S.of(context).activity_hike,
    ));
    _selectOutActivityList.add(_SelectActivity(
      type: ActivityItem.TYPE_SWIM,
      text: S.of(context).activity_swim,
    ));
    _selectOutActivityList.add(_SelectActivity(
      type: ActivityItem.TYPE_RUN,
      text: S.of(context).activity_run,
    ));
    _selectOutActivityList.add(_SelectActivity(
      type: ActivityItem.TYPE_BIKE,
      text: S.of(context).activity_bike,
    ));

    // For indoor
    _selectInActivityList = [];
    _selectInActivityList.add(_SelectActivity(
      type: ActivityItem.TYPE_READING,
      text: S.of(context).activity_reading,
    ));
    _selectInActivityList.add(_SelectActivity(
      type: ActivityItem.TYPE_COMPUTER,
      text: S.of(context).activity_front_computer,
    ));
    _selectInActivityList.add(_SelectActivity(
      type: ActivityItem.TYPE_TV,
      text: S.of(context).activity_tv,
    ));
    _selectInActivityList.add(_SelectActivity(
      type: ActivityItem.TYPE_PHONE,
      text: S.of(context).activity_using_phone,
    ));
    _selectInActivityList.add(_SelectActivity(
      type: ActivityItem.TYPE_GAMES,
      text: S.of(context).activity_playing_games,
    ));

    // Load customise history
    int inIndex = 1;
    int outIndex = 1;
    for (int i = _customList.length - 1; i >= 0; i--) {
      CustomType element = _customList[i];
      if (element.inOutDoor == ActivityItem.TYPE_INDOOR && inIndex < 5) {
        _selectInActivityList.add(_SelectActivity(
          type: ActivityItem.TYPE_OTHER_TOTAL << inIndex,
          customType: element,
        ));
        inIndex++;
      } else if (element.inOutDoor == ActivityItem.TYPE_OUTDOOR && outIndex < 5) {
        _selectOutActivityList.add(_SelectActivity(
          type: ActivityItem.TYPE_OTHER_TOTAL << outIndex,
          customType: element,
        ));
        outIndex++;
      }
    }

    // Load last customize
    _selectOutActivityList.add(_SelectActivity(
      type: ActivityItem.TYPE_CUSTOM,
      text: S.of(context).activity_customise,
    ));
    _selectInActivityList.add(_SelectActivity(
      type: ActivityItem.TYPE_CUSTOM,
      text: S.of(context).activity_customise,
    ));

    setState(() {});
  }
}

class _SelectActivity {
  int type;
  String text;
  CustomType customType;
  _SelectActivity({this.type, this.text, this.customType});
}
