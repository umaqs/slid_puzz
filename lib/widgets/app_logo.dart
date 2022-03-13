import 'package:flutter/material.dart';
import 'package:slide_puzzle/layout/layout.dart';
import 'package:slide_puzzle/themes/theme.notifier.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final layoutSize = context.layoutSize;
    final size = layoutSize.squareTileSize / 2;

    return Image.asset(
      'assets/images/cells.png',
      width: size,
      height: size,
      color: context.colors.primary,
    );
  }
}
