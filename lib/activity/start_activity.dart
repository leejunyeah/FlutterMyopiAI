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

  @override
  void initState() {
    super.initState();
    _isTargetChecked = false;
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
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(S.of(context).start_new_activity),
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
            _buiLdTargetTile(),
            _buildTimePicker(),
            Offstage(
              offstage: _isTargetChecked,
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
      offstage: !this._isTargetChecked,
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
                setState(() {
                  _targetTime = time;
                });
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
                S.of(context).start,
                style: TextStyle(fontSize: 18, color: Color(0xFFFFFFFF)),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0)),
              onPressed: _startAction,
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
          msg: S
              .of(context)
              .activity_empty_custom,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
        );
        return;
      }
    }
    ActivityItem activityItem = await _saveStart();
    int result = await Navigator.push(
      context,
      new MaterialPageRoute(
          builder: (context) => new RecordingActivity(
                activityItem: activityItem,
                isTargetChecked: _isTargetChecked,
              )),
    );
    if (result == HOME_TO_START_ACTIVITY) {
      Navigator.pop(context, HOME_TO_START_ACTIVITY);
    }
  }

  void _showIndoorActivityDialog() {
    var dialog = new Dialog(
      shape: CARD_SHAPE,
      child: new SingleChildScrollView(
        child: ListBody(children: <Widget>[
          Container(
            padding: EdgeInsets.all(24),
            child: Text(
              //'Activity',
              S.of(context).activity_title,
              style: TextStyle(fontSize: 20, color: Color(0xDD000000)),
            ),
          ),
          RadioListTile<int>(
              activeColor: COLOR_MAIN_GREEN,
              value: ActivityItem.TYPE_READING,
              title: Text(
                S.of(context).activity_reading,
                style: TextStyle(fontSize: 16, color: Color(0x89000000)),
              ),
              groupValue: _newActivityValue,
              onChanged: (value) {
                setState(() {
                  _newActivityValue = ActivityItem.TYPE_READING;
                  _newPickActivityString = S.of(context).activity_reading;
                });
                Navigator.of(context).pop();
              }),
          RadioListTile<int>(
              activeColor: COLOR_MAIN_GREEN,
              value: ActivityItem.TYPE_COMPUTER,
              title: Text(
                S.of(context).activity_front_computer,
                style: TextStyle(fontSize: 16, color: Color(0x89000000)),
              ),
              groupValue: _newActivityValue,
              onChanged: (value) {
                setState(() {
                  _newActivityValue = ActivityItem.TYPE_COMPUTER;
                  _newPickActivityString =
                      S.of(context).activity_front_computer;
                });
                Navigator.of(context).pop();
              }),
          RadioListTile<int>(
              activeColor: COLOR_MAIN_GREEN,
              value: ActivityItem.TYPE_TV,
              title: Text(
                S.of(context).activity_tv,
                style: TextStyle(fontSize: 16, color: Color(0x89000000)),
              ),
              groupValue: _newActivityValue,
              onChanged: (value) {
                setState(() {
                  _newActivityValue = ActivityItem.TYPE_TV;
                  _newPickActivityString = S.of(context).activity_tv;
                });
                Navigator.of(context).pop();
              }),
          RadioListTile<int>(
              activeColor: COLOR_MAIN_GREEN,
              value: ActivityItem.TYPE_PHONE,
              title: Text(
                S.of(context).activity_using_phone,
                style: TextStyle(fontSize: 16, color: Color(0x89000000)),
              ),
              groupValue: _newActivityValue,
              onChanged: (value) {
                setState(() {
                  _newActivityValue = ActivityItem.TYPE_PHONE;
                  _newPickActivityString = S.of(context).activity_using_phone;
                });
                Navigator.of(context).pop();
              }),
          RadioListTile<int>(
              activeColor: COLOR_MAIN_GREEN,
              value: ActivityItem.TYPE_CUSTOM,
              title: Text(
                S.of(context).activity_customise,
                style: TextStyle(fontSize: 16, color: Color(0x89000000)),
              ),
              groupValue: _newActivityValue,
              onChanged: (value) {
                setState(() {
                  _newActivityValue = ActivityItem.TYPE_CUSTOM;
                  _newPickActivityString = S.of(context).activity_customise;
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

  void _showOutdoorActivityDialog() {
    var dialog = new Dialog(
      shape: CARD_SHAPE,
      child: new SingleChildScrollView(
        child: ListBody(children: <Widget>[
          Container(
            padding: EdgeInsets.all(24),
            child: Text(
              S.of(context).activity_title,
              style: TextStyle(fontSize: 20, color: Color(0xDD000000)),
            ),
          ),
          RadioListTile<int>(
              activeColor: COLOR_MAIN_GREEN,
              value: ActivityItem.TYPE_SPORTS,
              title: Text(
                S.of(context).activity_sports,
                style: TextStyle(fontSize: 16, color: Color(0x89000000)),
              ),
              groupValue: _newActivityValue,
              onChanged: (value) {
                setState(() {
                  _newActivityValue = ActivityItem.TYPE_SPORTS;
                  _newPickActivityString = S.of(context).activity_sports;
                });
                Navigator.of(context).pop();
              }),
          RadioListTile<int>(
              activeColor: COLOR_MAIN_GREEN,
              value: ActivityItem.TYPE_HIKE,
              title: Text(
                S.of(context).activity_hike,
                style: TextStyle(fontSize: 16, color: Color(0x89000000)),
              ),
              groupValue: _newActivityValue,
              onChanged: (value) {
                setState(() {
                  _newActivityValue = ActivityItem.TYPE_HIKE;
                  _newPickActivityString = S.of(context).activity_hike;
                });
                Navigator.of(context).pop();
              }),
          RadioListTile<int>(
              activeColor: COLOR_MAIN_GREEN,
              value: ActivityItem.TYPE_SWIM,
              title: Text(
                S.of(context).activity_swim,
                style: TextStyle(fontSize: 16, color: Color(0x89000000)),
              ),
              groupValue: _newActivityValue,
              onChanged: (value) {
                setState(() {
                  _newActivityValue = ActivityItem.TYPE_SWIM;
                  _newPickActivityString = S.of(context).activity_swim;
                });
                Navigator.of(context).pop();
              }),
          RadioListTile<int>(
              activeColor: COLOR_MAIN_GREEN,
              value: ActivityItem.TYPE_CUSTOM,
              title: Text(
                S.of(context).activity_customise,
                style: TextStyle(fontSize: 16, color: Color(0x89000000)),
              ),
              groupValue: _newActivityValue,
              onChanged: (value) {
                setState(() {
                  _newActivityValue = ActivityItem.TYPE_CUSTOM;
                  _newPickActivityString = S.of(context).activity_customise;
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
    if (_newActivityValue == ActivityItem.TYPE_CUSTOM) {
      CustomType findType =
          await DatabaseHelper.internal().getCustomType(_newCustomTypeString);
      if (findType == null) {
        customTypeId = await DatabaseHelper.internal().getCustomTypeCount();
        customTypeId++;
        CustomType customType = new CustomType(
          id: customTypeId,
          typeText: _newCustomTypeString,
        );
        await DatabaseHelper.internal().insertCustomType(customType);
      } else {
        customTypeId = findType.id;
      }
    }

    int id = count + 1;
    ActivityItem activityItem = new ActivityItem(
      id: id,
      time: DateTime.now().millisecondsSinceEpoch,
      type: _newTypeValue | _newActivityValue,
      customType: customTypeId,
      target: _targetTime == null || !_isTargetChecked
          ? 0
          : _parseTargetTimeToSecond(),
      actual: 0,
    );
    await DatabaseHelper.internal().insertActivity(activityItem);
    return activityItem;
  }

  int _parseTargetTimeToSecond() {
    int targetTime = 0;
    if (_isTargetChecked && _targetTime != null) {
      targetTime = _targetTime.minute * 60 + _targetTime.hour * 60 * 60;
    }
    return targetTime;
  }
}
