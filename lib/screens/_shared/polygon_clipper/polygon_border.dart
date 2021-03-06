import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

import 'polygon_path_drawer.dart';

class PolygonBorder extends ShapeBorder {
  const PolygonBorder({
    required this.sides,
    this.rotate = 0.0,
    this.borderRadius = 0.0,
    this.border = BorderSide.none,
  });

  final int sides;
  final double rotate;
  final double borderRadius;
  final BorderSide border;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(border.width);

  Path _getPath(Rect rect, double radius) {
    final specs = PolygonPathSpecs(
      sides: sides < 3 ? 3 : sides,
      rotate: rotate,
      borderRadiusAngle: borderRadius,
    );

    return PolygonPathDrawer(size: Size.fromRadius(radius), specs: specs)
        .draw()
        .shift(Offset(rect.center.dx - radius, rect.center.dy - radius));
  }

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is PolygonBorder && a.sides == sides) {
      return PolygonBorder(
        sides: sides,
        rotate: lerpDouble(a.rotate, rotate, t) ?? 0,
        borderRadius: lerpDouble(a.borderRadius, borderRadius, t) ?? 0,
        border: BorderSide.lerp(a.border, border, t),
      );
    } else {
      return super.lerpFrom(a, t);
    }
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is PolygonBorder && b.sides == sides) {
      return PolygonBorder(
        sides: sides,
        rotate: lerpDouble(rotate, b.rotate, t) ?? 0,
        borderRadius: lerpDouble(borderRadius, b.borderRadius, t) ?? 0,
        border: BorderSide.lerp(border, b.border, t),
      );
    } else {
      return super.lerpTo(b, t);
    }
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    switch (border.style) {
      case BorderStyle.none:
        break;
      case BorderStyle.solid:
        final radius = (rect.shortestSide - border.width) / 2.0;
        final path = _getPath(rect, radius);
        canvas.drawPath(path, border.toPaint());
        break;
    }
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return _getPath(rect, math.max(0.0, rect.shortestSide / 2.0 - border.width));
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return _getPath(rect, math.max(0.0, rect.shortestSide / 2.0));
  }

  @override
  ShapeBorder scale(double t) {
    return PolygonBorder(sides: sides, rotate: rotate, borderRadius: borderRadius * t, border: border.scale(t));
  }

  @override
  int get hashCode {
    return sides.hashCode ^ rotate.hashCode ^ borderRadius.hashCode ^ border.hashCode;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (runtimeType != other.runtimeType) {
      return false;
    }

    return other is PolygonBorder &&
        sides == other.sides &&
        rotate == other.rotate &&
        borderRadius == other.borderRadius &&
        border == other.border;
  }
}
