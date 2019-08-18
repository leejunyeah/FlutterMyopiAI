import 'package:flutter/material.dart';
import 'package:flutter_myopia_ai/data/SortActivityItem.dart';
import 'package:flutter_myopia_ai/data/activity_item.dart';
import 'package:flutter_myopia_ai/util/myopia_const.dart';

class HomeProgressPainter extends CustomPainter {
  final List<SortActivityItem> sortedDataList;
  final List<Color> colorList;
  final int indoorOutdoorType;
  final bool forTotal;
  List<ProgressItem> _dataList;
  int _totalValue;

  HomeProgressPainter(
      {this.sortedDataList, this.colorList, this.indoorOutdoorType, this.forTotal = false}) {
    _dataList = new List();
    _totalValue = 0;
    if (sortedDataList != null) {
      if (forTotal) {
        for (SortActivityItem item in sortedDataList) {
          if (item == null) continue;
          if (item.totalTime < 60) continue;
          bool sortedIndoor = item.type & ActivityItem.TYPE_INDOOR != 0;
          ProgressItem pItem = _dataList.firstWhere((element) {
            if (sortedIndoor) {
              return element.type == ActivityItem.TYPE_INDOOR;
            } else {
              return element.type == ActivityItem.TYPE_OUTDOOR;
            }
          }, orElse: () => null);
          if (pItem == null) {
            ProgressItem pItem = new ProgressItem();
            pItem.type = sortedIndoor
                ? ActivityItem.TYPE_INDOOR
                : ActivityItem.TYPE_OUTDOOR;
            pItem.color = getActivityColor((sortedIndoor
                ? ActivityItem.TYPE_INDOOR
                : ActivityItem.TYPE_OUTDOOR));
            pItem.value = item.totalTime;
            pItem.customType = 0;
            _dataList.add(pItem);
          } else {
            pItem.value += item.totalTime;
          }
        }
        _dataList.sort((left, right) => left.type.compareTo(right.type));
      } else {
        List<ProgressItem> tempList = [];
        int index = 0;
        for (SortActivityItem item in sortedDataList) {
          if (item == null) continue;
          if (item.type & indoorOutdoorType == 0) continue;
          if (item.totalTime < 60) continue;
          Color color;
          if (colorList != null && index < colorList.length) {
            color = colorList[index];
          } else {
            color = COLOR_NONE;
          }
          ProgressItem pItem = new ProgressItem();
          pItem.type = item.type;
          pItem.color = color;
          pItem.value = item.totalTime;
          pItem.customType = item.customType;
          tempList.add(pItem);
          index++;
        }
        if (tempList.length > MAX_DETAIL_COUNT) {
          _dataList.addAll(tempList.sublist(0, MAX_DETAIL_COUNT));
          ProgressItem otherTotal = new ProgressItem();
          otherTotal.type = ActivityItem.TYPE_OTHER_TOTAL | indoorOutdoorType;
          otherTotal.customType = 0;
          otherTotal.value = 0;
          otherTotal.color = getActivityColor(otherTotal.type, index: -1);
          for (int i = MAX_DETAIL_COUNT; i < tempList.length; i++) {
            if (tempList[i].type & indoorOutdoorType == 0) continue;
            otherTotal.value += tempList[i].value;
          }
          if (otherTotal.value > 0) {
            _dataList.add(otherTotal);
          }
        } else {
          _dataList.addAll(tempList);
        }


      }
    }

    for (ProgressItem item in this._dataList) {
      _totalValue += item.value;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    double width = size.width;
    double top = size.height / 2 - 5.0;
    double startX = 0;
    int dataSize = _dataList.length;
    paint
      ..style = PaintingStyle.fill
      ..isAntiAlias = true
      ..strokeWidth = 1.0;
    // If the data value is very small, then its distance will be less than 10.0
    // In this case, the painter cannot draw it as normal
    // We must fix the value to make sure every distance is larger or equals than 10.0
    _fixDataValues(width);
    if (dataSize > 1) {
      ProgressItem firstItem = _dataList[0];
      ProgressItem lastItem = _dataList[dataSize - 1];
      double firstItemDistance = (firstItem.value / _totalValue) * width;
      double lastItemDistance = (lastItem.value / _totalValue) * width;
      startX += firstItemDistance;
      for (int i = 1; i < dataSize - 1; i++) {
        ProgressItem progressItem = _dataList[i];
        paint..color = progressItem.color;
        double distance = (progressItem.value / _totalValue) * width;
        canvas.drawRect(Rect.fromLTWH(startX, top, distance, 10), paint);
        progressItem.startX = startX;
        progressItem.endX = startX + distance;
        startX += distance;
      }
      //draw first
      paint..color = firstItem.color;
      canvas.drawRRect(
          RRect.fromRectAndCorners(
              Rect.fromLTWH(0, top, firstItemDistance, 10.0),
              topLeft: Radius.circular(10.0),
              bottomLeft: Radius.circular(10.0)),
          paint);
      firstItem.startX = 0;
      firstItem.endX = firstItemDistance;
      //draw last
      paint..color = lastItem.color;
      canvas.drawRRect(
          RRect.fromRectAndCorners(
              Rect.fromLTWH(
                  width - lastItemDistance, top, lastItemDistance, 10.0),
              topRight: Radius.circular(10.0),
              bottomRight: Radius.circular(10.0)),
          paint);
      lastItem.startX = width - lastItemDistance;
      lastItem.endX = width;
    } else if (dataSize == 1) {
      ProgressItem firstItem = _dataList[0];
      paint..color = firstItem.color;
      canvas.drawRRect(
          RRect.fromRectAndCorners(
            Rect.fromLTWH(startX, top, width, 10.0),
            topRight: Radius.circular(10.0),
            topLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0),
            bottomLeft: Radius.circular(10.0),
          ),
          paint);
      firstItem.startX = 0;
      firstItem.endX = width;
    } else {
      paint..color = COLOR_NONE;
      canvas.drawRRect(
          RRect.fromRectAndCorners(
            Rect.fromLTWH(startX, top, width, 10.0),
            topRight: Radius.circular(10.0),
            topLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0),
            bottomLeft: Radius.circular(10.0),
          ),
          paint);
    }
  }

  _fixDataValues(double width) {
    bool loop = false;
    for (ProgressItem p in _dataList) {
      double distance = (p.value / _totalValue) * width;
      if (distance < 5.0) {
        distance++;
        int newValue = ((distance / width) * _totalValue).toInt();
        _totalValue += (newValue - p.value);
        p.value = newValue;
        loop = true;
        break;
      }
    }
    if (loop) {
      _fixDataValues(width);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    if (this._dataList.length !=
        (oldDelegate as HomeProgressPainter)._dataList.length) return true;

    for (ProgressItem thisItem in this._dataList) {
      bool hasFound = false;
      for (ProgressItem oldItem
          in (oldDelegate as HomeProgressPainter)._dataList) {
        if (thisItem.type == oldItem.type && thisItem.value != oldItem.value) {
          return true;
        }
        if (thisItem.type == oldItem.type) {
          hasFound = true;
        }
      }
      if (!hasFound) return true;
    }
    return false;
  }

  List<double> getStartEndX(int type) {
    var result = [0.0, 0.0];
    for (ProgressItem item in _dataList) {
      if (item.type == type) {
        result = [item.startX, item.endX];
      }
    }
    return result;
  }

  List<ProgressItem> getDataList() {
    return _dataList;
  }

  int getTotalValue() {
    return _totalValue;
  }
}

class ProgressItem {
  int type;
  int customType;
  Color color;
  double startX;
  double endX;
  int value;
}
