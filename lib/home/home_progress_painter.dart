import 'package:flutter/material.dart';
import 'package:flutter_myopia_ai/data/activity_item.dart';
import 'package:flutter_myopia_ai/util/myopia_const.dart';

class HomeProgressPainter extends CustomPainter {
  final List<ActivityItem> activityList;
  final int indoorOutdoorType;
  final bool forTotal;
  List<ProgressItem> _dataList;
  int _totalValue;

  HomeProgressPainter(
      {this.activityList, this.indoorOutdoorType, this.forTotal = false}) {
    _dataList = new List();
    _totalValue = 0;
    if (activityList != null) {
      for (ActivityItem item in this.activityList) {
        if (item == null) continue;
        if (!forTotal) {
          if (item.type & indoorOutdoorType == 0) continue;
        }
        if (item.actual < 60) continue;
        ProgressItem pItem;
        for (ProgressItem i in this._dataList) {
          if (forTotal) {
            if (i.type & item.type != 0) {
              pItem = i;
            }
          } else {
            if (i.type == item.type) {
              pItem = i;
            }
          }
        }
        if (pItem == null) {
          pItem = new ProgressItem();
          pItem.type = forTotal
              ? ((item.type & ActivityItem.TYPE_INDOOR != 0)
                  ? ActivityItem.TYPE_INDOOR
                  : ActivityItem.TYPE_OUTDOOR)
              : item.type;
          pItem.color = getActivityColor(forTotal
              ? ((item.type & ActivityItem.TYPE_INDOOR != 0)
                  ? ActivityItem.TYPE_INDOOR
                  : ActivityItem.TYPE_OUTDOOR)
              : item.type);
          pItem.value = item.actual;
          _dataList.add(pItem);
        } else {
          pItem.value += item.actual;
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
  Color color;
  double startX;
  double endX;
  int value;
}
