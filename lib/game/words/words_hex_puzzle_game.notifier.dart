import 'dart:async';
import 'dart:math';

import 'package:slide_puzzle/game/_shared/shared.dart';
import 'package:slide_puzzle/game/hex/puzzle.dart';
import 'package:slide_puzzle/game/words/data/_data.dart';

class WordsHexPuzzleNotifier extends HexPuzzleNotifier {
  WordsHexPuzzleNotifier()
      : _letters = [],
        super(initialDepth: _depth);

  static const _depth = 2;

  int get minSize => _depth;

  int get maxSize => _depth;

  List<String> get letters => List.unmodifiable(_letters);
  List<String> _letters;

  List<String> get actualAnswers {
    return [
      _letters.take(3).join(''),
      _letters.skip(3).take(4).join(''),
      _letters.skip(3 + 4).take(5).join(''),
      _letters.skip(3 + 4 + 5).take(4).join(''),
      _letters.skip(3 + 4 + 5 + 4).take(3).join(''),
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
    final solution3 = solutions[3]!.keys;
    final solution4 = solutions[4]!.keys;
    final solution5 = solutions[5]!.keys;

    final random = Random();
    _letters = [
      ...solution3.elementAt(random.nextInt(solution3.length)).split(''),
      ...solution4.elementAt(random.nextInt(solution3.length)).split(''),
      ...solution5.elementAt(random.nextInt(solution3.length)).split(''),
      ...solution4.elementAt(random.nextInt(solution3.length)).split(''),
      ...solution3.elementAt(random.nextInt(solution3.length)).split(''),
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
      tiles.take(3).map((tile) => _letters[tile.value]).join(''),
      tiles.skip(3).take(4).map((tile) => _letters[tile.value]).join(''),
      tiles.skip(3 + 4).take(5).map((tile) => _letters[tile.value]).join(''),
      tiles.skip(3 + 4 + 5).take(4).map((tile) => _letters[tile.value]).join(''),
      tiles.skip(3 + 4 + 5 + 4).take(3).map((tile) => _letters[tile.value]).join(''),
    ];

    final solutions = [
      for (final word in words) dictionaries[word.length]!.containsKey(word),
    ];

    print('Actual Answers: $actualAnswers');
    final complete = solutions.every((solution) => solution);
    if (complete) {
      print('Your Answers: $words');
    }
    return complete;
  }
}
