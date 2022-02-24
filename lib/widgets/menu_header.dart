import 'package:flutter/material.dart';
import 'package:slide_puzzle/layout/layout.dart';
import 'package:slide_puzzle/widgets/widgets.dart';

class MenuHeader extends StatelessWidget {
  const MenuHeader({
    Key? key,
    required this.title,
  }) : super(key: key);

  final PuzzleTitle title;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      small: (_, child) => Padding(
        padding: kPadding16,
        child: child!,
      ),
      medium: (_, child) => Padding(
        padding: kPadding24,
        child: child!,
      ),
      large: (_, child) => SizedBox(
        height: ResponsiveLayoutSize.large.squareBoardSize,
        child: child!,
      ),
      child: (layoutSize, _) {
        return Column(
          crossAxisAlignment: layoutSize.isLarge ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          children: [
            title,
          ],
        );
      },
    );
  }
}
