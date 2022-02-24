import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:slide_puzzle/app/app.dart';
import 'package:slide_puzzle/layout/layout.dart';
import 'package:slide_puzzle/widgets/widgets.dart';

import 'menu.dart';

class PicturesMenuLayout implements PageLayoutDelegate<PicturesMenuNotifier> {
  const PicturesMenuLayout(this.notifier);

  final PicturesMenuNotifier notifier;

  Widget startSection(BuildContext context, BoxConstraints constraints) {
    return MenuHeader(
      title: PuzzleTitle(title: 'Pick One!'),
    );
  }

  Widget body(context, constraints) {
    return MenuGrid(
      gridSize: notifier.gridSize,
      tiles: [
        for (int i = 0; i < notifier.items.length; i++) gridItem(context, i),
      ],
    );
  }

  Widget endSection(context, constraints) {
    return MenuFooter();
  }

  @override
  Widget gridItem(BuildContext context, int index) {
    final item = notifier.items[index];
    final isLoading = notifier.isLoading;

    return MenuItemTile(
      key: Key('${item.key}'),
      item: item,
      isLoading: isLoading,
      onTap: isLoading || item.data == null
          ? null
          : () {
              context.goNamed(
                RouteNames.picturesPuzzle,
                extra: item.data!,
              );
            },
    );
  }
}
