import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slide_puzzle/app/app.dart';
import 'package:slide_puzzle/game/_shared/shared.dart';
import 'package:slide_puzzle/game/square/puzzle.dart';
import 'package:slide_puzzle/screens/_base/infrastructure.dart';
import 'package:slide_puzzle/screens/_shared/shared.dart';
import 'package:slide_puzzle/screens/numbers/numbers.square.layout.dart';

class NumbersSquareScreen extends StatelessWidget {
  const NumbersSquareScreen._({
    Key? key,
    required this.notifier,
  }) : super(key: key);

  final SquarePuzzleNotifier notifier;

  static ScaleTransitionPage buildPage(BuildContext context) {
    return ScaleTransitionPage(
      key: const ValueKey(RouteNames.numbersSquare),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<GameTimerNotifier>(create: (_) => GameTimerNotifier(const Ticker())),
          ChangeNotifierProvider<CountdownNotifier>(create: (_) => CountdownNotifier(const Ticker())),
        ],
        builder: (_, __) => ProvideNotifier<PuzzleGameNotifier>(
          watch: true,
          create: (context) => SquarePuzzleNotifier(
            context.read<CountdownNotifier>(),
            context.read<GameTimerNotifier>(),
          ),
          builder: (_, notifier) => NumbersSquareScreen._(notifier: notifier as SquarePuzzleNotifier),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ThemeAwareScaffold(
      pageLayoutDelegate: NumbersSquareLayout(notifier),
    );
  }
}
