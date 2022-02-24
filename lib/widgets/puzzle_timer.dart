import 'package:flutter/material.dart';
import 'package:slide_puzzle/layout/layout.dart';
import 'package:slide_puzzle/themes/themes.dart';
import 'package:slide_puzzle/typography/typography.dart';

class PuzzleTimer extends StatelessWidget {
  const PuzzleTimer({
    Key? key,
    required this.duration,
    this.textStyle,
    this.iconSize,
    this.iconPadding,
    this.mainAxisAlignment,
  }) : super(key: key);

  final Duration duration;
  final TextStyle? textStyle;
  final double? iconSize;
  final double? iconPadding;
  final MainAxisAlignment? mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
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
        final currentTextStyle = textStyle ?? layoutSize.defaultTextStyle;

        return Row(
          mainAxisAlignment: mainAxisAlignment ?? layoutSize.mainAxisAlignment,
          children: [
            AnimatedDefaultTextStyle(
              style: currentTextStyle.copyWith(color: context.colors.primary),
              duration: kThemeAnimationDuration,
              child: Text(
                _formatDuration(duration),
                key: ValueKey(duration.inSeconds),
              ),
            ),
            SizedBox(width: iconPadding ?? 8),
            Icon(
              Icons.timer,
              size: iconSize ?? layoutSize.timerIconSize,
              color: context.colors.primary,
            ),
          ],
        );
      },
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    final twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
  }
}

extension _ResponsiveLayoutSizeExtension on ResponsiveLayoutSize {
  TextStyle get defaultTextStyle {
    return this.isLarge ? PuzzleTextStyle.headline4 : PuzzleTextStyle.headline5;
  }

  double get timerIconSize {
    switch (this) {
      case ResponsiveLayoutSize.small:
        return 28;
      default:
        return 30;
    }
  }

  MainAxisAlignment get mainAxisAlignment {
    return this.isLarge ? MainAxisAlignment.start : MainAxisAlignment.center;
  }
}
