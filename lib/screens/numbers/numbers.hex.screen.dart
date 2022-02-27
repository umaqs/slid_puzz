import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slide_puzzle/app/app.dart';
import 'package:slide_puzzle/game/_shared/shared.dart';
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
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<GameTimerNotifier>(create: (_) => GameTimerNotifier(const Ticker())),
          ChangeNotifierProvider<CountdownNotifier>(create: (_) => CountdownNotifier(const Ticker())),
        ],
        builder: (_, __) => ProvideNotifier<HexPuzzleNotifier>(
          watch: true,
          create: (context) => HexPuzzleNotifier(
            context.read<CountdownNotifier>(),
            context.read<GameTimerNotifier>(),
          ),
          builder: (_, notifier) => NumbersHexScreen._(notifier: notifier),
        ),
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
