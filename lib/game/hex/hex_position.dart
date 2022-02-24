import 'dart:math';
import 'dart:ui';

import 'package:slide_puzzle/game/_shared/shared.dart';

/// {@template hex_position}
/// Hex grid position model.
///
/// (1, 1) is the top left corner of the board.
/// {@endtemplate}
class HexPosition extends Position {
  /// {@macro position}
  HexPosition.axial(num x, num y) : super(x, y);

  num get q => x;

  num get r => y;

  num get s => -q - r;

  /// Checks whether both positions are on either same column or same row
  bool isAlignedWith(Position other) {
    if (other is HexPosition) {
      return q == other.q || r == other.r || s == other.s;
    }
    return false;
  }

  @override
  Offset get toOffset {
    final x = q * sqrt(3) + r * sqrt(3) / 2;
    final y = r * 3 / 2.0;
    return Offset(x, y);
  }
}
