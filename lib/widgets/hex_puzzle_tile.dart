import 'package:flutter/material.dart';
import 'package:hexagon/hexagon.dart';
import 'package:slide_puzzle/layout/layout.dart';
import 'package:slide_puzzle/widgets/animations/animated_hover_interaction.dart';
import 'package:slide_puzzle/widgets/animations/tile_animation.dart';

class HexPuzzleTile extends StatelessWidget {
  const HexPuzzleTile({
    Key? key,
    required this.offset,
    required this.gridDepth,
    required this.color,
    required this.childBuilder,
    this.elevation = 12,
    this.borderColor,
    this.borderWidth,
    this.tilt = true,
    this.showWhitespaceTile = false,
  }) : super(key: key);

  final Offset offset;
  final int gridDepth;
  final Color color;
  final Color? borderColor;
  final double? borderWidth;
  final double elevation;
  final bool tilt;
  final bool showWhitespaceTile;
  final WidgetBuilder childBuilder;

  @override
  Widget build(BuildContext context) {
    final layoutSize = context.layoutSize;
    final scale = gridDepth.tileScale;
    final tileSize = layoutSize.hexTileWidth * scale;

    final offsetScaleFactor = gridDepth.offsetScaleFactor;
    final offset = this.offset.scale(offsetScaleFactor, offsetScaleFactor);

    final alignment = FractionalOffset.fromOffsetAndSize(
          offset,
          Size.square(1 + gridDepth * 2.0),
        ) *
        offsetScaleFactor;

    Widget buildChild() {
      final child = HexagonWidget.pointy(
        inBounds: false,
        color: color,
        cornerRadius: layoutSize.hexTileCornerRadius,
        width: tileSize,
        child: childBuilder(context),
      );
      if (borderColor == null) {
        return child;
      }
      return HexagonWidget.pointy(
        inBounds: false,
        elevation: elevation,
        color: borderColor,
        cornerRadius: layoutSize.hexTileCornerRadius,
        width: tileSize + (borderWidth ?? (layoutSize.isSmall ? 4 : 8)),
        child: child,
      );
    }

    return TileAnimation(
      offset: FractionalOffset.center.add(alignment) as FractionalOffset,
      duration: Duration(milliseconds: 300 * gridDepth),
      child: Opacity(
        opacity: showWhitespaceTile ? 0.2 : 1,
        child: AnimatedHoverInteraction(
          enabled: tilt && !showWhitespaceTile,
          tilt: true,
          child: SizedBox.square(
            dimension: tileSize,
            child: buildChild(),
          ),
        ),
      ),
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
