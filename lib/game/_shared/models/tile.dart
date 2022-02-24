import 'package:equatable/equatable.dart';

import 'position.dart';

/// {@template tile}
/// Base model for a puzzle tile.
/// {@endtemplate}
abstract class Tile<P extends Position> extends Equatable {
  /// {@macro tile}
  const Tile({
    required this.value,
    required this.correctPosition,
    required this.currentPosition,
    this.isWhitespace = false,
  });

  /// Value representing the correct position of [Tile] in a list.
  final int value;

  /// The correct 2D [Position] of the [Tile]. All tiles must be in their
  /// correct position to complete the puzzle.
  final P correctPosition;

  /// The current 2D [Position] of the [Tile].
  final P currentPosition;

  /// Denotes if the [Tile] is the whitespace tile or not.
  final bool isWhitespace;

  /// Denotes if the [Tile] is in its correct position
  bool get hasCorrectPosition => currentPosition == correctPosition;

  /// Checks whether both tiles are on either same column or same row
  bool isAlignedWith(Tile other) {
    return other.currentPosition.isAlignedWith(currentPosition);
  }

  /// Create a copy of this [Tile] with updated current position.
  Tile copyWith({required P currentPosition});

  @override
  List<Object> get props => [
        value,
        correctPosition,
        currentPosition,
        isWhitespace,
      ];
}
