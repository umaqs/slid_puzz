import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slide_puzzle/audio/audio.dart';
import 'package:slide_puzzle/game/_shared/shared.dart';
import 'package:slide_puzzle/layout/layout.dart';
import 'package:slide_puzzle/screens/_base/infrastructure.dart';
import 'package:slide_puzzle/themes/themes.dart';
import 'package:slide_puzzle/typography/typography.dart';

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
        return 'Get Ready ${status == CountdownStatus.running ? secondsToBegin : ''}';
      case GameState.ready:
        return 'Let\'s Go!';
      case GameState.inProgress:
        return status == CountdownStatus.elapsed ? 'Go!' : 'Tick Tock!';
      case GameState.paused:
        return 'Paused!';
      case GameState.completed:
        return 'Well Done!';
    }
  }

  @override
  Widget build(BuildContext context) {
    final titleColor = context.colors.primary;

    return Listen<CountdownNotifier>(
      listener: (notifier) {
        if (notifier.status != CountdownStatus.running) {
          return;
        }
        if (notifier.secondsToBegin == notifier.totalSeconds) {
          context.read<AudioNotifier>().play(AudioAssets.shuffle);
        }
      },
      child: ResponsiveLayoutBuilder(
        small: (_, child) => child!,
        medium: (_, child) => Padding(
          padding: kPadding24,
          child: child!,
        ),
        large: (_, child) => Padding(
          padding: kEdgePadding8,
          child: child!,
        ),
        child: (layoutSize, _) {
          final textStyle = layoutSize.textStyle.copyWith(color: titleColor);

          final countdownNotifier = context.watch<CountdownNotifier>();
          final status = countdownNotifier.status;
          final secondsToBegin = countdownNotifier.secondsToBegin;

          return AnimatedDefaultTextStyle(
            style: textStyle,
            duration: kThemeChangeDuration,
            child: Text(
              _getTitle(status, secondsToBegin),
              textAlign: layoutSize.textAlign,
            ),
          );
        },
      ),
    );
  }
}

extension _ResponsiveLayoutSizeExtension on ResponsiveLayoutSize {
  TextStyle get textStyle {
    return this.isLarge ? PuzzleTextStyle.headline2 : PuzzleTextStyle.headline3;
  }

  TextAlign get textAlign {
    return this.isLarge ? TextAlign.left : TextAlign.center;
  }
}
