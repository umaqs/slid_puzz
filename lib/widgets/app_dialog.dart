import 'package:flutter/material.dart';
import 'package:slide_puzzle/layout/layout.dart';
import 'package:slide_puzzle/themes/themes.dart';

class AppDialog extends StatelessWidget {
  const AppDialog({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      small: (_, __) => Material(
        child: SizedBox.expand(
          child: child,
        ),
      ),
      medium: (_, child) => child!,
      large: (_, child) => child!,
      child: (layoutSize, _) {
        final dialogWidth = layoutSize == ResponsiveLayoutSize.large ? 740.0 : 700.0;

        return Dialog(
          clipBehavior: Clip.hardEdge,
          backgroundColor: context.colors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: kBorderRadius12,
          ),
          child: SizedBox(
            width: dialogWidth,
            child: child,
          ),
        );
      },
    );
  }
}
