import 'package:flutter/material.dart';
import 'package:slide_puzzle/layout/layout.dart';

class MenuGrid extends StatelessWidget {
  const MenuGrid({
    Key? key,
    required this.gridSize,
    required this.tiles,
    this.spacing = 8,
  }) : super(key: key);

  final int gridSize;
  final double spacing;
  final List<Widget> tiles;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: context.layoutSize.squareBoardSize,
      child: GridView.count(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: gridSize,
        mainAxisSpacing: spacing,
        crossAxisSpacing: spacing,
        children: tiles,
      ),
    );
  }
}
