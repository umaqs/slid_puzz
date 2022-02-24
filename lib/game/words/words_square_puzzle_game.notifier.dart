import 'dart:async';
import 'dart:math';

import 'package:slide_puzzle/game/_shared/shared.dart';
import 'package:slide_puzzle/game/square/puzzle.dart';
import 'package:slide_puzzle/game/words/data/_data.dart';

class WordsSquarePuzzleNotifier extends SquarePuzzleNotifier {
  WordsSquarePuzzleNotifier({
    int initialGridSize = 4,
  })  : _letters = [],
        super(initialGridSize: initialGridSize);

  @override
  int get minSize => 3;

  @override
  int get maxSize => 6;

  List<String> get letters => List.unmodifiable(_letters);
  List<String> _letters;

  List<String> get actualAnswers {
    return [
      for (var i = 0; i < gridSize; i++) ...[
        _letters.skip(gridSize * i).take(gridSize).join(''),
      ],
    ];
  }

  bool get isCompleted {
    if (super.isCompleted) {
      return true;
    }

    return _hasMatchingWords();
  }

  @override
  void nextState() {
    switch (gameState) {
      case GameState.gettingReady:
        break;
      case GameState.ready:
        _shuffle(startGame: true, shuffleIterations: 3, addDelay: true);
        break;
      case GameState.inProgress:
        pause();
        break;
      case GameState.paused:
        start();
        break;
      case GameState.completed:
        generatePuzzle(startGame: true, shuffleIterations: 3, addDelay: true);
        break;
    }
  }

  Future<void> _shuffle({
    bool startGame = false,
    int shuffleIterations = 0,
    bool addDelay = false,
  }) async {
    super.generatePuzzle(
      startGame: startGame,
      shuffleIterations: shuffleIterations,
      addDelay: addDelay,
    );
  }

  @override
  Future<void> generatePuzzle({
    bool startGame = false,
    int shuffleIterations = 0,
    bool addDelay = false,
  }) async {
    final solutionGrid = solutions[gridSize]!.keys;

    final random = Random();
    _letters = [
      for (var i = 0; i < gridSize; i++) ...[
        ...solutionGrid.elementAt(random.nextInt(solutionGrid.length)).split(''),
      ],
    ];
    super.generatePuzzle(
      startGame: startGame,
      shuffleIterations: shuffleIterations,
      addDelay: addDelay,
    );
  }

  bool _hasMatchingWords() {
    final tiles = puzzle.tiles;

    if (!tiles.last.isWhitespace) {
      return false;
    }

    final words = [
      for (var i = 0; i < gridSize; i++) ...[
        tiles.skip(gridSize * i).take(gridSize).map((tile) => _letters[tile.value]).join(''),
      ],
    ];

    final dictGrid = dictionaries[gridSize]!;
    final solutions = [
      for (var i = 0; i < gridSize; i++) dictGrid.containsKey(words[i]),
    ];

    return solutions.every((solution) => solution);
  }
}
