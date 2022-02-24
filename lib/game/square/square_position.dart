import 'package:slide_puzzle/game/_shared/shared.dart';

/// {@template square_position}
/// 2-dimensional position model.
///
/// (1, 1) is the top left corner of the board.
/// {@endtemplate}
class SquarePosition extends Position {
  /// {@macro square_position}
  const SquarePosition(int x, int y) : super(x, y);

  /// Checks whether both positions are on either same column or same row
  bool isAlignedWith(Position other) => x == other.x || y == other.y;
}
