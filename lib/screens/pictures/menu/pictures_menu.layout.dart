import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:slide_puzzle/app/app.dart';
import 'package:slide_puzzle/layout/layout.dart';
import 'package:slide_puzzle/services/snackbar.service.dart';
import 'package:slide_puzzle/themes/themes.dart';
import 'package:slide_puzzle/widgets/widgets.dart';

import 'menu.dart';

class PicturesMenuLayout implements PageLayoutDelegate<PicturesMenuNotifier> {
  const PicturesMenuLayout(this.notifier);

  @override
  final PicturesMenuNotifier notifier;

  @override
  Widget startSection(BuildContext context, BoxConstraints constraints) {
    return const MenuHeader(title: 'Pick One!');
  }

  @override
  Widget body(BuildContext context, BoxConstraints constraints) {
    return MenuGrid(
      gridSize: notifier.gridSize,
      tiles: [
        for (int i = 0; i < notifier.items.length; i++) gridItem(context, i),
      ],
    );
  }

  @override
  Widget endSection(BuildContext context, BoxConstraints constraints) {
    return MenuFooter(
      children: [
        const ResponsiveGap(
          small: 32,
          medium: 48,
        ),
        _buildMenuButtons(context),
        const ResponsiveGap(
          small: 32,
          medium: 48,
        ),
      ],
    );
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
              context.pushNamed(
                RouteNames.picturesPuzzle,
                extra: item.data,
              );
            },
    );
  }

  Widget _buildMenuButtons(BuildContext context) {
    final colors = context.colors;

    Future<void> _onTap(BuildContext context, ImageSource source) async {
      final imageParts = await notifier.pickImage(source);
      if (imageParts != null) {
        // ignore: use_build_context_synchronously
        context.pushNamed(RouteNames.picturesPuzzle, extra: imageParts);
      } else {
        final error = notifier.error;
        if (error != null) {
          SnackBarService.instance.showSnackBar(message: error);
        }
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Tooltip(
          waitDuration: const Duration(seconds: 1),
          message: 'Choose your own picture',
          child: SquareButton(
            borderRadius: 8,
            color: colors.primary,
            onTap: notifier.isLoading ? null : () => _onTap(context, ImageSource.gallery),
            child: Icon(
              Icons.image,
              size: 30,
              color: colors.surface,
            ),
          ),
        ),
        const ResponsiveGap(
          small: 8,
          medium: 12,
          large: 16,
        ),
        Tooltip(
          waitDuration: const Duration(seconds: 1),
          message: 'Refresh pictures',
          child: SquareButton(
            borderRadius: 8,
            color: colors.primary,
            onTap: notifier.isLoading
                ? null
                : () {
                    notifier.reloadMenu();
                  },
            child: Icon(
              Icons.refresh,
              size: 30,
              color: colors.surface,
            ),
          ),
        ),
      ],
    );
  }
}
