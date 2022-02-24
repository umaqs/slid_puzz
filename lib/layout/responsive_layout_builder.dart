import 'package:flutter/widgets.dart';
import 'package:slide_puzzle/layout/layout.dart';

/// Signature for the individual builders (`small`, `medium`, `large`).
typedef ResponsiveLayoutWidgetBuilder = Widget Function(BuildContext, Widget?);

/// {@template responsive_layout_builder}
/// A wrapper around [LayoutBuilder] which exposes builders for
/// various responsive breakpoints.
/// {@endtemplate}
class ResponsiveLayoutBuilder extends StatelessWidget {
  /// {@macro responsive_layout_builder}
  const ResponsiveLayoutBuilder({
    Key? key,
    required this.small,
    required this.medium,
    required this.large,
    this.child,
  }) : super(key: key);

  /// [ResponsiveLayoutWidgetBuilder] for small layout.
  final ResponsiveLayoutWidgetBuilder small;

  /// [ResponsiveLayoutWidgetBuilder] for medium layout.
  final ResponsiveLayoutWidgetBuilder medium;

  /// [ResponsiveLayoutWidgetBuilder] for large layout.
  final ResponsiveLayoutWidgetBuilder large;

  /// Optional child widget builder based on the current layout size
  /// which will be passed to the `small`, `medium` and `large` builders
  /// as a way to share/optimize shared layout.
  final Widget Function(ResponsiveLayoutSize currentSize, BoxConstraints constraints)? child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;

        if (screenWidth <= PuzzleBreakpoints.small) {
          return small(
            context,
            child?.call(
              ResponsiveLayoutSize.small,
              constraints,
            ),
          );
        }
        if (screenWidth <= PuzzleBreakpoints.medium) {
          return medium(
            context,
            child?.call(
              ResponsiveLayoutSize.medium,
              constraints,
            ),
          );
        }
        if (screenWidth <= PuzzleBreakpoints.large) {
          return large(
            context,
            child?.call(
              ResponsiveLayoutSize.large,
              constraints,
            ),
          );
        }

        return large(
          context,
          child?.call(
            ResponsiveLayoutSize.large,
            constraints,
          ),
        );
      },
    );
  }
}
