import 'package:flutter/material.dart';
import 'package:slide_puzzle/layout/layout.dart';
import 'package:slide_puzzle/themes/themes.dart';
import 'package:slide_puzzle/typography/typography.dart';

/// {@template puzzle_title}
/// Displays the title of the puzzle in the given color.
/// {@endtemplate}
class PuzzleTitle extends StatelessWidget {
  /// {@macro puzzle_title}
  const PuzzleTitle({
    Key? key,
    required this.title,
    this.color,
  }) : super(key: key);

  /// The title to be displayed.
  final String title;

  /// The color of [title], defaults to [PuzzleTheme.titleColor].
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final titleColor = context.colors.primary;

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
        final textStyle = layoutSize.textStyle.copyWith(color: titleColor);

        return AnimatedDefaultTextStyle(
          style: textStyle,
          duration: kThemeChangeDuration,
          child: Text(
            title,
            textAlign: layoutSize.textAlign,
          ),
        );
      },
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
