import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slide_puzzle/game/_shared/puzzle_game.notifier.dart';
import 'package:slide_puzzle/layout/layout.dart';
import 'package:slide_puzzle/themes/themes.dart';
import 'package:slide_puzzle/typography/typography.dart';
import 'package:slide_puzzle/widgets/widgets.dart';

class PuzzleScore extends StatelessWidget {
  const PuzzleScore({
    Key? key,
    required this.screenshot,
  }) : super(key: key);

  final Uint8List screenshot;

  @override
  Widget build(BuildContext context) {
    final moveCount = context.select<PuzzleGameNotifier, int>((notifier) => notifier.moveCount);

    return ResponsiveLayoutBuilder(
      small: (_, child) => child!,
      medium: (_, child) => child!,
      large: (_, child) => child!,
      child: (layoutSize, _) {
        final height = layoutSize == ResponsiveLayoutSize.small ? 374.0 : 355.0;

        final wellDoneTextStyle =
            layoutSize == ResponsiveLayoutSize.small ? PuzzleTextStyle.headline4Soft : PuzzleTextStyle.headline3;

        final timerTextStyle =
            layoutSize == ResponsiveLayoutSize.small ? PuzzleTextStyle.headline5 : PuzzleTextStyle.headline4;

        final timerIconSize = layoutSize == ResponsiveLayoutSize.small ? 21.0 : 28.0;

        final timerIconPadding = layoutSize == ResponsiveLayoutSize.small ? 4.0 : 6.0;

        final numberOfMovesTextStyle =
            layoutSize == ResponsiveLayoutSize.small ? PuzzleTextStyle.headline5 : PuzzleTextStyle.headline4;

        final colors = context.colors;

        return ClipRRect(
          borderRadius: kBorderRadius12,
          child: Container(
            width: double.infinity,
            height: height,
            color: context.colors.primaryContainer,
            child: Stack(
              children: [
                Align(
                  alignment: FractionalOffset.topRight,
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..scale(0.85, 0.85)
                      ..rotateZ(pi * 0.2),
                    child: Image.memory(
                      screenshot,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: kPadding24.add(const EdgeInsets.only(top: 12)),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          colors.tertiaryContainer.withOpacity(0.1),
                          colors.tertiaryContainer.withOpacity(0.7),
                          colors.tertiaryContainer,
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const ResponsiveGap(
                          medium: 32,
                          large: 32,
                        ),
                        Text(
                          'Congrats!',
                          style: wellDoneTextStyle.copyWith(
                            color: colors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const ResponsiveGap(
                          small: 12,
                          medium: 12,
                          large: 12,
                        ),
                        PuzzleTimer(
                          textStyle: timerTextStyle,
                          iconSize: timerIconSize,
                          iconPadding: timerIconPadding,
                          mainAxisAlignment: MainAxisAlignment.start,
                        ),
                        const ResponsiveGap(
                          small: 2,
                          medium: 8,
                          large: 8,
                        ),
                        Text(
                          '$moveCount Moves',
                          style: numberOfMovesTextStyle.copyWith(
                            color: colors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
