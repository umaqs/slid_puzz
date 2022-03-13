import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:slide_puzzle/layout/layout.dart';

/// Represents the layout size passed to [ResponsiveLayoutBuilder.child].
enum ResponsiveLayoutSize {
  /// Small layout
  small,

  /// Medium layout
  medium,

  /// Large layout
  large
}

extension ResponsiveLayoutSizeCtxExtension on BuildContext {
  ResponsiveLayoutSize get layoutSize {
    final screenWidth = MediaQuery.of(this).size.width;

    if (screenWidth <= PuzzleBreakpoints.small) {
      return ResponsiveLayoutSize.small;
    }
    if (screenWidth <= PuzzleBreakpoints.medium) {
      return ResponsiveLayoutSize.medium;
    }
    return ResponsiveLayoutSize.large;
  }
}

extension ResponsiveLayoutSizeExtension on ResponsiveLayoutSize {
  bool get isLarge => this == ResponsiveLayoutSize.large;
  bool get isSmall => this == ResponsiveLayoutSize.small;

  Axis get screenLayoutAxis {
    switch (this) {
      case ResponsiveLayoutSize.small:
        return Axis.vertical;
      case ResponsiveLayoutSize.medium:
        return Axis.vertical;
      case ResponsiveLayoutSize.large:
        return Axis.horizontal;
    }
  }

  Axis get buttonLayoutAxis {
    switch (this) {
      case ResponsiveLayoutSize.small:
        return Axis.horizontal;
      case ResponsiveLayoutSize.medium:
        return Axis.horizontal;
      case ResponsiveLayoutSize.large:
        return Axis.vertical;
    }
  }

  double get squareBoardSize {
    switch (this) {
      case ResponsiveLayoutSize.small:
        return 312;
      case ResponsiveLayoutSize.medium:
        return 424;
      case ResponsiveLayoutSize.large:
        return 472;
    }
  }

  double get hexBoardSize {
    switch (this) {
      case ResponsiveLayoutSize.small:
        return 420;
      case ResponsiveLayoutSize.medium:
        return 500;
      case ResponsiveLayoutSize.large:
        return 600;
    }
  }

  double get squareTileSize {
    switch (this) {
      case ResponsiveLayoutSize.small:
        return 78.0;
      case ResponsiveLayoutSize.medium:
        return 106.0;
      case ResponsiveLayoutSize.large:
        return 118.0;
    }
  }

  double get tileFontSize {
    switch (this) {
      case ResponsiveLayoutSize.small:
        return 36.0;
      case ResponsiveLayoutSize.medium:
        return 42.0;
      case ResponsiveLayoutSize.large:
        return 54.0;
    }
  }

  double get buttonFontSize {
    switch (this) {
      case ResponsiveLayoutSize.small:
        return 16;
      case ResponsiveLayoutSize.medium:
        return 24;
      case ResponsiveLayoutSize.large:
        return 32;
    }
  }

  double get hexTileWidth {
    switch (this) {
      case ResponsiveLayoutSize.small:
        return kIsWeb ? 88.0 : 80;
      case ResponsiveLayoutSize.medium:
        return 100.0;
      case ResponsiveLayoutSize.large:
        return 125.0;
    }
  }

  double get hexTileCornerRadius {
    switch (this) {
      case ResponsiveLayoutSize.small:
        return 6;
      case ResponsiveLayoutSize.medium:
        return 8;
      case ResponsiveLayoutSize.large:
        return 12;
    }
  }
}

const kEdgePadding4 = EdgeInsets.symmetric(horizontal: 4);
const kEdgePadding8 = EdgeInsets.symmetric(horizontal: 8);
const kEdgePadding16 = EdgeInsets.symmetric(horizontal: 16);
const kEdgePadding24 = EdgeInsets.symmetric(horizontal: 24);

const kPadding2 = EdgeInsets.all(2);
const kPadding4 = EdgeInsets.all(4);
const kPadding8 = EdgeInsets.all(8);
const kPadding16 = EdgeInsets.all(16);
const kPadding24 = EdgeInsets.all(24);

const kBox4 = SizedBox(width: 4, height: 4);
const kBox8 = SizedBox(width: 8, height: 8);
const kBox12 = SizedBox(width: 12, height: 12);
const kBox16 = SizedBox(width: 16, height: 16);
const kBox24 = SizedBox(width: 24, height: 24);

final kBorderRadius8 = BorderRadius.circular(8);
final kBorderRadius12 = BorderRadius.circular(12);
final kBorderRadius22 = BorderRadius.circular(22);
