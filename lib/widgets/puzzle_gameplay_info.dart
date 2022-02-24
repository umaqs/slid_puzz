import 'package:flutter/material.dart';
import 'package:slide_puzzle/layout/layout.dart';
import 'package:slide_puzzle/themes/themes.dart';
import 'package:slide_puzzle/typography/typography.dart';

class PuzzleGameplayInfo extends StatelessWidget {
  const PuzzleGameplayInfo({
    Key? key,
    required this.numberOfMoves,
    required this.numberOfTilesLeft,
    this.textStyle,
  }) : super(key: key);

  final int numberOfMoves;
  final int numberOfTilesLeft;
  final TextStyle? textStyle;

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

        final children = [
          AnimatedDefaultTextStyle(
            style: currentTextStyle.copyWith(color: context.colors.primary),
            duration: kThemeAnimationDuration,
            child: Text(
              '$numberOfMoves Moves',
            ),
          ),
          kBox16,
          AnimatedDefaultTextStyle(
            style: currentTextStyle.copyWith(color: context.colors.primary),
            duration: kThemeAnimationDuration,
            child: Text(
              '$numberOfTilesLeft Tiles',
            ),
          ),
        ];

        if (layoutSize.isLarge) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          );
        }
        return SizedBox(
          width: layoutSize.squareBoardSize,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: children,
          ),
        );
      },
    );
  }
}

extension _ResponsiveLayoutSizeExtension on ResponsiveLayoutSize {
  TextStyle get defaultTextStyle {
    return this.isLarge ? PuzzleTextStyle.headline4 : PuzzleTextStyle.headline5;
  }
}
