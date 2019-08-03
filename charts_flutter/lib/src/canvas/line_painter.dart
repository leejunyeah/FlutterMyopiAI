// Copyright 2018 the Charts project authors. Please see the AUTHORS file
// for details.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:ui' as ui show Shader;
import 'dart:math';
import 'dart:math' show Point, Rectangle;
import 'package:flutter/material.dart';
import 'package:charts_common/common.dart' as common show Color;

/// Draws a simple line.
///
/// Lines may be styled with dash patterns similar to stroke-dasharray in SVG
/// path elements. Dash patterns are currently only supported between vertical
/// or horizontal line segments at this time.
class LinePainter {
  /// Draws a simple line.
  ///
  /// [dashPattern] controls the pattern of dashes and gaps in a line. It is a
  /// list of lengths of alternating dashes and gaps. The rendering is similar
  /// to stroke-dasharray in SVG path elements. An odd number of values in the
  /// pattern will be repeated to derive an even number of values. "1,2,3" is
  /// equivalent to "1,2,3,1,2,3."
  void draw(
      {Canvas canvas,
      Paint paint,
      List<Point> points,
      Rectangle<num> clipBounds,
      common.Color fill,
      common.Color stroke,
      bool roundEndCaps,
      double strokeWidthPx,
      List<int> dashPattern,
      ui.Shader shader}) {
    if (points.isEmpty) {
      return;
    }

    // Apply clip bounds as a clip region.
    if (clipBounds != null) {
      canvas
        ..save()
        ..clipRect(new Rect.fromLTWH(
            clipBounds.left.toDouble(),
            clipBounds.top.toDouble(),
            clipBounds.width.toDouble(),
            clipBounds.height.toDouble()));
    }

    paint.color = new Color.fromARGB(stroke.a, stroke.r, stroke.g, stroke.b);
    if (shader != null) {
      paint.shader = shader;
    }

    // If the line has a single point, draw a circle.
    if (points.length == 1) {
      final point = points.first;
      paint.style = PaintingStyle.fill;
      canvas.drawCircle(new Offset(point.x, point.y), strokeWidthPx, paint);
    } else {
      if (strokeWidthPx != null) {
        paint.strokeWidth = strokeWidthPx;
      }
      paint.strokeJoin = StrokeJoin.round;
      paint.style = PaintingStyle.stroke;

      if (dashPattern == null || dashPattern.isEmpty) {
        if (roundEndCaps == true) {
          paint.strokeCap = StrokeCap.round;
        }

        _drawSmoothLine(canvas, paint, points);
//        _drawSolidLine(canvas, paint, points);
      } else {
        _drawDashedLine(canvas, paint, points, dashPattern);
      }
    }

    if (clipBounds != null) {
      canvas.restore();
    }
  }

  /// Draws solid lines between each point.
  void _drawSolidLine(Canvas canvas, Paint paint, List<Point> points) {
    // TODO: Extract a native line component which constructs the
    // appropriate underlying data structures to avoid conversion.
    final path = new Path()
      ..moveTo(points.first.x.toDouble(), points.first.y.toDouble());

    for (var point in points) {
      path.lineTo(point.x.toDouble(), point.y.toDouble());
    }

    canvas.drawPath(path, paint);
  }

  /// Draws smooth lines between each point.
  void _drawSmoothLine(Canvas canvas, Paint paint, List<Point> points) {
    var targetPoints = List<Point>();
    targetPoints.addAll(points);
    targetPoints.add(Point(
        points[points.length - 1].x * 2, points[points.length - 1].y * 2));
    double x0, y0, x1, y1, t0;
    Path path = Path();
    for (int i = 0; i < targetPoints.length; i++) {
      double t1;
      num x = targetPoints[i].x;
      num y = targetPoints[i].y;
      if (x == x1 && y == y1) return;
      switch (i) {
        case 0:
          path.moveTo(x.toDouble(), y.toDouble());
          break;
        case 1:
          break;
        case 2:
          t1 = _slope3(x0, y0, x1, y1, x.toDouble(), y.toDouble());
          _point(path, x0, y0, x1, y1, _slope2(x0, y0, x1, y1, t1), t1);
          break;
        default:
          t1 = _slope3(x0, y0, x1, y1, x, y);
          _point(path, x0, y0, x1, y1, t0, t1);
      }
      x0 = x1;
      y0 = y1;
      x1 = x.toDouble();
      y1 = y.toDouble();
      t0 = t1;
    }
    canvas.drawPath(path, paint);
  }

  double _sign(x) {
    return x < 0 ? -1 : 1;
  }

  double _slope2(x0, y0, x1, y1, t) {
    var h = x1 - x0;
    return h != 0 ? (3 * (y1 - y0) / h - t) / 2 : t;
  }

  double _slope3(double x0, double y0, double x1, double y1, double x2, double y2) {
    double h0 = x1 - x0;
    double h1 = x2 - x1;
    double s0 = (y1 - y0) / h0;
    double s1 = (y2 - y1) / h1;
    double p = (s0 * h1 + s1 * h0) / (h0 + h1);
    return (_sign(s0) + _sign(s1)) * min(s0.abs(), min(s1.abs(), 0.5 * p.abs()));
  }

  _point(Path path, x0, y0, x1, y1, t0, t1) {
    var dx = (x1 - x0) / 3;
    path.cubicTo(x0 + dx, y0 + dx * t0, x1 - dx, y1 - dx * t1, x1, y1);
  }

  /// Draws dashed lines lines between each point.
  void _drawDashedLine(
      Canvas canvas, Paint paint, List<Point> points, List<int> dashPattern) {
    final localDashPattern = new List.from(dashPattern);

    // If an odd number of parts are defined, repeat the pattern to get an even
    // number.
    if (dashPattern.length % 2 == 1) {
      localDashPattern.addAll(dashPattern);
    }

    // Stores the previous point in the series.
    var previousSeriesPoint = _getOffset(points.first);

    var remainder = 0;
    var solid = true;
    var dashPatternIndex = 0;

    // Gets the next segment in the dash pattern, looping back to the
    // beginning once the end has been reached.
    var getNextDashPatternSegment = () {
      final dashSegment = localDashPattern[dashPatternIndex];
      dashPatternIndex = (dashPatternIndex + 1) % localDashPattern.length;
      return dashSegment;
    };

    // Array of points that is used to draw a connecting path when only a
    // partial dash pattern segment can be drawn in the remaining length of a
    // line segment (between two defined points in the shape).
    var remainderPoints;

    // Draw the path through all the rest of the points in the series.
    for (var pointIndex = 1; pointIndex < points.length; pointIndex++) {
      // Stores the current point in the series.
      final seriesPoint = _getOffset(points[pointIndex]);

      if (previousSeriesPoint == seriesPoint) {
        // Bypass dash pattern handling if the points are the same.
      } else {
        // Stores the previous point along the current series line segment where
        // we rendered a dash (or left a gap).
        var previousPoint = previousSeriesPoint;

        var d = _getOffsetDistance(previousSeriesPoint, seriesPoint);

        while (d > 0) {
          var dashSegment =
              remainder > 0 ? remainder : getNextDashPatternSegment();
          remainder = 0;

          // Create a unit vector in the direction from previous to next point.
          final v = seriesPoint - previousPoint;
          final u = new Offset(v.dx / v.distance, v.dy / v.distance);

          // If the remaining distance is less than the length of the dash
          // pattern segment, then cut off the pattern segment for this portion
          // of the overall line.
          final distance = d < dashSegment ? d : dashSegment.toDouble();

          // Compute a vector representing the length of dash pattern segment to
          // be drawn.
          final nextPoint = previousPoint + (u * distance);

          // If we are in a solid portion of the dash pattern, draw a line.
          // Else, move on.
          if (solid) {
            if (remainderPoints != null) {
              // If we had a partial un-drawn dash from the previous point along
              // the line, draw a path that includes it and the end of the dash
              // pattern segment in the current line segment.
              remainderPoints.add(new Offset(nextPoint.dx, nextPoint.dy));

              final path = new Path()
                ..moveTo(remainderPoints.first.dx, remainderPoints.first.dy);

              for (var p in remainderPoints) {
                path.lineTo(p.dx, p.dy);
              }

              canvas.drawPath(path, paint);

              remainderPoints = null;
            } else {
              if (d < dashSegment && pointIndex < points.length - 1) {
                // If the remaining distance d is too small to fit this dash,
                // and we have more points in the line, save off a series of
                // remainder points so that we can draw a path segment moving in
                // the direction of the next point.
                //
                // Note that we don't need to save anything off for the "blank"
                // portions of the pattern because we still take the remaining
                // distance into account before starting the next dash in the
                // next line segment.
                remainderPoints = [
                  new Offset(previousPoint.dx, previousPoint.dy),
                  new Offset(nextPoint.dx, nextPoint.dy)
                ];
              } else {
                // Otherwise, draw a simple line segment for this dash.
                canvas.drawLine(previousPoint, nextPoint, paint);
              }
            }
          }

          solid = !solid;
          previousPoint = nextPoint;
          d = d - dashSegment;
        }

        // Save off the remaining distance so that we can continue the dash (or
        // gap) into the next line segment.
        remainder = -d.round();

        // If we have a remaining un-drawn distance for the current dash (or
        // gap), revert the last change to "solid" so that we will continue
        // either drawing a dash or leaving a gap.
        if (remainder > 0) {
          solid = !solid;
        }
      }

      previousSeriesPoint = seriesPoint;
    }
  }

  /// Converts a [Point] into an [Offset].
  Offset _getOffset(Point point) =>
      new Offset(point.x.toDouble(), point.y.toDouble());

  /// Computes the distance between two [Offset]s, as if they were [Point]s.
  num _getOffsetDistance(Offset o1, Offset o2) {
    final p1 = new Point(o1.dx, o1.dy);
    final p2 = new Point(o2.dx, o2.dy);
    return p1.distanceTo(p2);
  }
}
