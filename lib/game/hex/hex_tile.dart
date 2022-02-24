import 'package:slide_puzzle/game/_shared/models/models.dart';
import 'package:slide_puzzle/game/hex/hex_position.dart';

/// {@template hex_tile}
/// Model for a hex puzzle tile.
/// {@endtemplate}
class HexTile extends Tile<HexPosition> {
  /// {@macro hex_tile}
  HexTile({
    required int value,
    required HexPosition correctPosition,
    required HexPosition currentPosition,
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
  HexTile copyWith({required HexPosition currentPosition}) {
    return HexTile(
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
