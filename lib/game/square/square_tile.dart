import 'package:slide_puzzle/game/_shared/models/models.dart';
import 'package:slide_puzzle/game/square/puzzle.dart';

/// {@template square_tile}
/// Model for a square puzzle tile.
/// {@endtemplate}
class SquareTile extends Tile<SquarePosition> {
  /// {@macro square_tile}
  SquareTile({
    required int value,
    required SquarePosition correctPosition,
    required SquarePosition currentPosition,
    bool isWhitespace = false,
  }) : super(
          value: value,
          correctPosition: correctPosition,
          currentPosition: currentPosition,
          isWhitespace: isWhitespace,
        );

  // Checks whether both tiles are on either same column or same row
  bool isAlignedWith(Tile other) {
    return other.currentPosition.isAlignedWith(currentPosition);
  }

  /// Create a copy of this [Tile] with updated current position.
  SquareTile copyWith({required SquarePosition currentPosition}) {
    return SquareTile(
      value: value,
      correctPosition: correctPosition,
      currentPosition: currentPosition,
      isWhitespace: isWhitespace,
    );
  }

  @override
  List<Object> get props => [
        value,
        correctPosition,
        currentPosition,
        isWhitespace,
      ];
}
