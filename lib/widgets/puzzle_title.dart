import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slide_puzzle/game/_shared/shared.dart';
import 'package:slide_puzzle/layout/layout.dart';
import 'package:slide_puzzle/themes/themes.dart';
import 'package:slide_puzzle/typography/typography.dart';
import 'package:slide_puzzle/widgets/widgets.dart';

class PuzzleTitle extends StatelessWidget {
  const PuzzleTitle({
    Key? key,
    required this.gameState,
    this.color,
  }) : super(key: key);

  /// The title to be displayed.
  final GameState gameState;

  /// The color of [gameState], defaults to [PuzzleTheme.titleColor].
  final Color? color;

  String _getTitle(CountdownStatus status, int secondsToBegin) {
    switch (gameState) {
      case GameState.gettingReady:
        return status == CountdownStatus.elapsed
            ? 'Go!'
            : 'Get Ready ${status == CountdownStatus.running ? secondsToBegin : ''}';
      case GameState.ready:
        return "Let's Go!";
      case GameState.inProgress:
        return 'Tick Tock!';
      case GameState.paused:
        return 'Paused!';
      case GameState.completed:
        return 'Well Done!';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (gameState.inProgress || gameState.paused) {
      return const PuzzleTimer();
    }

    final titleColor = context.colors.primary;
    final layoutSize = context.layoutSize;

    final textStyle = layoutSize.textStyle.copyWith(color: titleColor);

    final countdownNotifier = context.watch<CountdownNotifier>();
    final status = countdownNotifier.status;
    final secondsToBegin = countdownNotifier.secondsToBegin;

    return Text(
      _getTitle(status, secondsToBegin),
      style: textStyle,
      textAlign: layoutSize.textAlign,
    );
  }
}

extension _ResponsiveLayoutSizeExtension on ResponsiveLayoutSize {
  TextStyle get textStyle {
    return isLarge ? PuzzleTextStyle.headline2 : PuzzleTextStyle.headline3;
  }

  TextAlign get textAlign {
    return isLarge ? TextAlign.left : TextAlign.center;
  }
}
