import 'package:flutter/material.dart';

/// Represents the layout size passed to [ResponsiveLayoutBuilder.child].
enum ResponsiveLayoutSize {
  /// Small layout
  small,

  /// Medium layout
  medium,

  /// Large layout
  large
}

extension ResponsiveLayoutSizeExtension on ResponsiveLayoutSize {
  bool get isLarge => this == ResponsiveLayoutSize.large;

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
        return 75.0;
      case ResponsiveLayoutSize.medium:
        return 100.0;
      case ResponsiveLayoutSize.large:
        return 112.0;
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
}

final kEdgePadding4 = EdgeInsets.symmetric(horizontal: 4);
final kEdgePadding8 = EdgeInsets.symmetric(horizontal: 8);
final kEdgePadding16 = EdgeInsets.symmetric(horizontal: 16);
final kEdgePadding24 = EdgeInsets.symmetric(horizontal: 24);

final kPadding4 = EdgeInsets.all(4);
final kPadding8 = EdgeInsets.all(8);
final kPadding16 = EdgeInsets.all(16);
final kPadding24 = EdgeInsets.all(24);

final kBox4 = SizedBox(width: 4, height: 4);
final kBox8 = SizedBox(width: 8, height: 8);
final kBox16 = SizedBox(width: 16, height: 16);
final kBox24 = SizedBox(width: 24, height: 24);

final kBorderRadius8 = BorderRadius.circular(8);
final kBorderRadius12 = BorderRadius.circular(12);
