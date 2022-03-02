import 'package:flutter/material.dart';
import 'package:hexagon/hexagon.dart';
import 'package:slide_puzzle/layout/layout.dart';
import 'package:slide_puzzle/widgets/animations/animated_hover_interaction.dart';

class HexPuzzleTile extends StatelessWidget {
  HexPuzzleTile({
    Key? key,
    required this.offset,
    required this.gridDepth,
    required this.color,
    required this.childBuilder,
    this.showWhitespaceTile = false,
  }) : super(key: key);

  final Offset offset;
  final int gridDepth;
  final Color color;
  final bool showWhitespaceTile;
  final Widget Function(BuildContext context, ResponsiveLayoutSize layoutSize) childBuilder;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      small: (_, child) => child!,
      medium: (_, child) => child!,
      large: (_, child) => child!,
      child: (layoutSize, constraints) {
        final scale = gridDepth.tileScale;
        final tileSize = layoutSize.hexTileWidth * scale;

        final offsetScaleFactor = gridDepth.offsetScaleFactor;
        final offset = this.offset.scale(offsetScaleFactor, offsetScaleFactor);

        final alignment = FractionalOffset.fromOffsetAndSize(
              offset,
              Size.square(1 + gridDepth * 2.0),
            ) *
            offsetScaleFactor;

        return AnimatedAlign(
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 300),
          alignment: FractionalOffset.center.add(alignment),
          child: Opacity(
            opacity: showWhitespaceTile ? 0.2 : 1,
            child: AnimatedHoverInteraction(
              enabled: !showWhitespaceTile,
              tilt: true,
              child: SizedBox.square(
                dimension: tileSize,
                child: HexagonWidget.pointy(
                  inBounds: false,
                  elevation: 12,
                  color: color,
                  cornerRadius: layoutSize.hexTileCornerRadius,
                  width: tileSize,
                  child: childBuilder(context, layoutSize),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

extension _GridDepthExtension on int {
  double get tileScale {
    if (this == 1) {
      return 1.2;
    }
    if (this == 2) {
      return 0.8;
    }
    if (this == 3) {
      return 0.64;
    }
    return 0.5;
  }

  double get offsetScaleFactor {
    if (this == 3) {
      return 0.82;
    }
    return 0.8;
  }
}
