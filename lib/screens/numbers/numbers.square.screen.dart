import 'package:flutter/material.dart';
import 'package:slide_puzzle/app/app.dart';
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
      key: ValueKey(RouteNames.numbersSquare),
      child: ProvideNotifier<SquarePuzzleNotifier>(
        watch: true,
        create: (context) => SquarePuzzleNotifier(),
        builder: (_, notifier) => NumbersSquareScreen._(notifier: notifier),
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
