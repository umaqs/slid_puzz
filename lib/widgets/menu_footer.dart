import 'package:flutter/material.dart';
import 'package:slide_puzzle/layout/layout.dart';

class MenuFooter extends StatelessWidget {
  const MenuFooter({
    Key? key,
    required this.children,
  }) : super(key: key);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      small: (_, child) => child!,
      medium: (_, child) => child!,
      large: (_, child) => SizedBox(
        height: ResponsiveLayoutSize.large.squareBoardSize,
        child: child,
      ),
      child: (layoutSize, _) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: children,
        );
      },
    );
  }
}
