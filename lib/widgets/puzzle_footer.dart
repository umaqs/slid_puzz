import 'package:flutter/material.dart';
import 'package:slide_puzzle/game/_shared/shared.dart';
import 'package:slide_puzzle/layout/layout.dart';
import 'package:slide_puzzle/widgets/widgets.dart';

class PuzzleFooter extends StatelessWidget {
  const PuzzleFooter({
    Key? key,
    required this.gameState,
    required this.primaryButton,
    this.secondaryButton,
    this.gridSizePicker,
    this.showValueCheckbox,
  }) : super(key: key);

  final GameState gameState;

  final Widget primaryButton;

  final Widget? secondaryButton;

  final GridSizePicker? gridSizePicker;

  final Widget? showValueCheckbox;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      small: (_, child) => child!,
      medium: (_, child) => child!,
      large: (_, child) => SizedBox(
        height: ResponsiveLayoutSize.large.squareBoardSize,
        child: child!,
      ),
      child: (layoutSize, _) {
        return SizedBox(
          width: layoutSize.squareBoardSize,
          child: Padding(
            padding: layoutSize.isLarge ? kEdgePadding24 : kEdgePadding8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (showValueCheckbox != null) ...[
                  showValueCheckbox!,
                  ResponsiveGap(
                    small: 4,
                    medium: 8,
                    large: 16,
                  ),
                ],
                if (gridSizePicker != null) ...[
                  gridSizePicker!,
                  ResponsiveGap(
                    small: 8,
                    medium: 16,
                    large: 24,
                  ),
                ],
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (secondaryButton != null) ...[
                      SizedBox.square(
                        dimension: layoutSize.squareTileSize,
                        child: secondaryButton!,
                      ),
                      ResponsiveGap(
                        small: 8,
                        medium: 12,
                        large: 16,
                      ),
                    ],
                    SizedBox.square(
                      dimension: layoutSize.squareTileSize,
                      child: primaryButton,
                    ),
                  ],
                ),
                ResponsiveGap(
                  small: 16,
                  medium: 16,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
