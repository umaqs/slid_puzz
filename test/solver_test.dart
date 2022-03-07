// ignore_for_file: avoid_print

import 'package:slide_puzzle/game/_shared/shared.dart';
import 'package:slide_puzzle/game/_shared/solver/puzzle.solver.dart';
import 'package:slide_puzzle/game/square/puzzle.dart';
import 'package:test/test.dart';

Future<void> main() async {
  group('A* star path finder', () {
    late int gridSize;
    late PuzzleSolver solver;

    late GameTimerNotifier timer;
    late CountdownNotifier countdown;
    late SquarePuzzleNotifier notifier;

    late SquareGridPuzzle startPuzzle;
    late SquareGridPuzzle solvedPuzzle;

    setUp(() async {
      gridSize = 4;
      timer = GameTimerNotifier(const Ticker());
      countdown = CountdownNotifier(const Ticker());
      notifier = SquarePuzzleNotifier(countdown, timer, initialGridSize: gridSize);
      await notifier.generatePuzzle();
      startPuzzle = notifier.puzzle;

      solvedPuzzle = SquareGridPuzzle(tiles: [...notifier.puzzle.tiles]);

      await notifier.generatePuzzle(shuffle: true);

      solver = PuzzleSolver<SquareTile>(start: notifier.puzzle, goal: solvedPuzzle);
    });

    tearDown(() {
      notifier.dispose();
      countdown.dispose();
      timer.dispose();
    });

    test('Find path', () async {
      final startedAt = DateTime.now();
      print('Started At: $startedAt');

      print(startPuzzle.tiles.map((t) => t.value).join(','));

      final solution = await solver.solve();
      // final solution = await solver.solve();

      final solvedAt = DateTime.now();
      print('solved at: $solvedAt');

      print('solved in steps: ${solution.length}');
      print(solution.map((tile) => '${tile.value}').join(','));

      print('SOLUTION');
      // var state = startState;
      for (final step in solution) {
        print(step.value);
        print('=======================');
        // if (step.actionIndex != null) {
        //   state = state.moveTile(step.actionIndex!);
        // }
      }

      expect(solution, isNotEmpty);
    });
  });
}
