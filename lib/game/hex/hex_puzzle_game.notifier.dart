import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:hexagon/src/grid/coordinates.dart';
import 'package:slide_puzzle/game/_shared/shared.dart';
import 'package:slide_puzzle/game/hex/puzzle.dart';

class HexPuzzleNotifier extends GameTimerNotifier implements PuzzleGameNotifier<HexTile> {
  HexPuzzleNotifier({
    int initialDepth = 2,
  })  : assert(
          initialDepth >= _minDepth && initialDepth <= _maxDepth,
          'Depth should range from $_minDepth to $_maxDepth',
        ),
        _gridDepth = initialDepth,
        _gameState = GameState.gettingReady,
        super(const Ticker()) {
    generatePuzzle();
  }

  static const _minDepth = 2;
  static const _maxDepth = 4;

  int get minSize => _minDepth;

  int get maxSize => _maxDepth;

  int get _maxHexCount => 1 + (_gridDepth * 2);

  int get gridSize => _gridDepth;
  int _gridDepth;

  int get moveCount => _moveCount;
  int _moveCount = 0;

  int get secondsToBegin => _secondsToBegin;
  int _secondsToBegin = 0;

  GameState get gameState => _gameState;
  GameState _gameState;

  HexGridPuzzle get puzzle => _puzzle;
  late HexGridPuzzle _puzzle;

  set gridSize(int value) {
    if (value == _gridDepth) {
      return;
    }
    if (value >= minSize && value <= maxSize) {
      _gridDepth = value;
      generatePuzzle();
    }
  }

  bool get isCompleted => _puzzle.isComplete;

  @override
  bool showCorrectTileIndicator(HexTile tile) {
    if (tile.isWhitespace) {
      return false;
    }
    if (!_gameState.inProgress || !_gameState.completed) {
      return false;
    }
    return tile.hasCorrectPosition;
  }

  @override
  Future<void> generatePuzzle({
    bool startGame = false,
    int shuffleIterations = 0,
    bool addDelay = false,
  }) async {
    stop();
    _gameState = GameState.gettingReady;
    notifyListeners();

    if (shuffleIterations > 0) {
      startCountdown(countdownSeconds: shuffleIterations);
    }

    final correctPositions = _generatePositions();
    final currentPositions = [...correctPositions];

    final tiles = _generateTileListFromPositions(correctPositions, currentPositions);

    if (shuffleIterations == 0) {
      _puzzle = HexGridPuzzle(tiles: tiles);
    } else {
      _secondsToBegin = shuffleIterations;
      notifyListeners();
      for (var i = 0; i < shuffleIterations; i++) {
        _shuffleTilesAndCreatePuzzle(tiles, tileShuffleIterations: _gridDepth * 100);
        notifyListeners();
        if (addDelay) {
          await Future<void>.delayed(const Duration(seconds: 1));
        }
        _secondsToBegin--;
        notifyListeners();
      }
    }

    if (startGame) {
      start();
    } else {
      _gameState = GameState.ready;
      notifyListeners();
    }
  }

  List<HexPosition> _generatePositions() {
    final positions = <HexPosition>[];

    for (var mainIndex = 0; mainIndex < _maxHexCount; mainIndex++) {
      final r = mainIndex - _gridDepth;
      final crossCount = _maxHexCount - r.abs();
      for (var crossIndex = 0; crossIndex < crossCount; crossIndex++) {
        int q;
        if (r <= 0)
          q = -_gridDepth - r + crossIndex;
        else
          q = -_gridDepth + crossIndex;

        final position = HexPosition.axial(q, r);
        positions.add(position);
      }
    }

    return positions;
  }

  /// Build a list of tiles - giving each tile their correct position and a
  /// current position.
  List<HexTile> _generateTileListFromPositions(
    List<HexPosition> correctPositions,
    List<HexPosition> currentPositions,
  ) {
    return List.generate(
      currentPositions.length,
      (i) => HexTile(
        value: i,
        correctPosition: correctPositions[i],
        currentPosition: currentPositions[i],
        isWhitespace: i == correctPositions.length - 1,
      ),
    );
  }

  void _shuffleTilesAndCreatePuzzle(List<HexTile> tiles, {int tileShuffleIterations = 200}) {
    final random = Random();
    var puzzle = HexGridPuzzle(tiles: [...tiles]);
    while (tileShuffleIterations > 0) {
      final moveIndex = random.nextInt(puzzle.tiles.length);
      final tileToMove = puzzle.tiles[moveIndex];
      if (puzzle.isTileMovable(tileToMove)) {
        puzzle = HexGridPuzzle(
          tiles: puzzle.moveTiles(tileToMove, []).sort(),
        );
        tileShuffleIterations--;
      }
    }

    _puzzle = puzzle;
  }

  int getTileIndexAtCoordinates(Coordinates coordinates) {
    return _puzzle.tiles.indexWhere((tile) {
      final currentPosition = tile.currentPosition;
      return currentPosition.q == coordinates.q && currentPosition.r == coordinates.r;
    });
  }

  void moveTile(HexTile tile) {
    if (_gameState.inProgress) {
      if (_puzzle.isTileMovable(tile)) {
        final mutablePuzzle = HexGridPuzzle(tiles: [..._puzzle.tiles]);
        final puzzle = mutablePuzzle.moveTiles(tile, []);
        _puzzle = HexGridPuzzle(tiles: puzzle.sort());
        if (isCompleted) {
          _gameState = GameState.completed;
        }
        _moveCount++;
        notifyListeners();
      }
    }
  }

  void nextState() {
    switch (_gameState) {
      case GameState.gettingReady:
        break;
      case GameState.ready:
      case GameState.completed:
        generatePuzzle(startGame: true, shuffleIterations: 3, addDelay: true);
        break;
      case GameState.inProgress:
        pause();
        break;
      case GameState.paused:
        start();
        break;
    }
  }

  @override
  @protected
  void start() {
    _gameState = GameState.inProgress;
    super.start();
  }

  @override
  @protected
  void pause() {
    _gameState = GameState.paused;
    super.pause();
  }
}
