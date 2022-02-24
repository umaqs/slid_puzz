import 'package:flutter/material.dart';
import 'package:slide_puzzle/app/app.dart';
import 'package:slide_puzzle/game/hex/hex_puzzle_game.notifier.dart';
import 'package:slide_puzzle/screens/_base/infrastructure.dart';
import 'package:slide_puzzle/screens/_shared/shared.dart';
import 'package:slide_puzzle/screens/numbers/numbers.hex.layout.dart';

class NumbersHexScreen extends StatelessWidget {
  const NumbersHexScreen._({
    Key? key,
    required this.notifier,
  }) : super(key: key);

  final HexPuzzleNotifier notifier;

  static ScaleTransitionPage buildPage(BuildContext context) {
    return ScaleTransitionPage(
      key: ValueKey(RouteNames.numbersHex),
      child: ProvideNotifier<HexPuzzleNotifier>(
        watch: true,
        create: (context) => HexPuzzleNotifier(),
        builder: (context, notifier) => NumbersHexScreen._(notifier: notifier),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ThemeAwareScaffold(
      pageLayoutDelegate: NumbersHexLayout(notifier),
    );
  }
}
