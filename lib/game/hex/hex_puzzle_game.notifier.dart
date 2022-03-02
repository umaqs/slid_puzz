import 'dart:async';

import 'package:hexagon/src/grid/coordinates.dart';
import 'package:slide_puzzle/game/_shared/shared.dart';
import 'package:slide_puzzle/game/hex/puzzle.dart';
import 'package:slide_puzzle/screens/_base/base.notifier.dart';

class HexPuzzleNotifier extends BaseNotifier implements PuzzleGameNotifier<HexTile> {
  HexPuzzleNotifier(
    this._countdown,
    this._timer, {
    int initialDepth = 2,
  })  : assert(
          initialDepth >= _minDepth && initialDepth <= _maxDepth,
          'Depth should range from $_minDepth to $_maxDepth',
        ),
        _gridDepth = initialDepth,
        _gameState = GameState.gettingReady {
    generatePuzzle();
  }

  final CountdownNotifier _countdown;
  final GameTimerNotifier _timer;

  static const _minDepth = 2;
  static const _maxDepth = 4;

  int get minSize => _minDepth;

  int get maxSize => _maxDepth;

  int get _maxHexCount => 1 + (_gridDepth * 2);

  int get gridSize => _gridDepth;
  int _gridDepth;

  int get moveCount => _moveCount;
  int _moveCount = 0;

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
      notifyListeners();
      generatePuzzle();
    }
  }

  bool get isCompleted => _puzzle.isComplete;

  int getTileIndexAtCoordinates(Coordinates coordinates) {
    return _puzzle.tiles.indexWhere((tile) {
      final currentPosition = tile.currentPosition;
      return currentPosition.q == coordinates.q && currentPosition.r == coordinates.r;
    });
  }

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
    bool shuffle = false,
  }) async {
    _getRead();

    final correctPositions = _generatePositions();
    final currentPositions = [...correctPositions];

    var tiles = _generateTileListFromPositions(correctPositions, currentPositions);
    _puzzle = HexGridPuzzle(tiles: tiles);

    if (shuffle) {
      while (puzzle.numberOfCorrectTiles != 0) {
        currentPositions.shuffle();
        tiles = _generateTileListFromPositions(
          correctPositions,
          currentPositions,
        );
        _puzzle = HexGridPuzzle(tiles: tiles).sort();
      }
    }

    if (startGame) {
      _countdown.start(onComplete: start);
    } else {
      _gameState = GameState.ready;
      notifyListeners();
    }
  }

  void moveTile(HexTile tile) {
    if (_gameState.inProgress) {
      if (_puzzle.isTileMovable(tile)) {
        final mutablePuzzle = HexGridPuzzle(tiles: [..._puzzle.tiles]);
        _puzzle = mutablePuzzle.moveTiles(tile, []).sort();
        if (isCompleted) {
          _gameState = GameState.completed;
          _timer.pause();
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
        generatePuzzle(startGame: true, shuffle: true);
        break;
      case GameState.inProgress:
        pause();
        break;
      case GameState.paused:
        start();
        break;
    }
  }

  void pause() {
    _gameState = GameState.paused;
    _timer.pause();
    notifyListeners();
  }

  void start() {
    _gameState = GameState.inProgress;
    _timer.start();
    notifyListeners();
  }

  void _getRead() {
    _moveCount = 0;
    _gameState = GameState.gettingReady;
    _timer.stop();
    notifyListeners();
  }

  /// Create all possible board positions.
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
}
