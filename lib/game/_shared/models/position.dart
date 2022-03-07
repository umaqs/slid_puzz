import 'dart:ui';

import 'package:equatable/equatable.dart';

/// {@template position}
/// 2-dimensional position model.
/// {@endtemplate}
abstract class Position extends Equatable implements Comparable<Position> {
  /// {@macro position}
  const Position(this.x, this.y);

  /// The x position.
  final num x;

  /// The y position.
  final num y;

  /// Checks whether both positions are on either same column or same row
  bool isAlignedWith(Position other);

  @override
  List<Object> get props => [x, y];

  @override
  int compareTo(Position other) {
    if (y < other.y) {
      return -1;
    } else if (y > other.y) {
      return 1;
    } else {
      if (x < other.x) {
        return -1;
      } else if (x > other.x) {
        return 1;
      } else {
        return 0;
      }
    }
  }

  Offset get toOffset {
    return Offset(x.toDouble(), y.toDouble());
  }

  num distance(Position other) {
    final dx = x - other.x;
    final dy = y - other.y;
    return dx.abs() + dy.abs();
  }
}
