import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:slide_puzzle/app/app.dart';
import 'package:slide_puzzle/layout/layout.dart';
import 'package:slide_puzzle/screens/pictures/menu/widgets/search_field.dart';
import 'package:slide_puzzle/themes/themes.dart';
import 'package:slide_puzzle/typography/text_styles.dart';
import 'package:slide_puzzle/widgets/widgets.dart';

import 'menu.dart';

class PicturesMenuLayout implements PageLayoutDelegate<PicturesMenuNotifier> {
  const PicturesMenuLayout(this.notifier);

  @override
  final PicturesMenuNotifier notifier;

  @override
  Widget startSection(BuildContext context, BoxConstraints constraints) {
    return MenuHeader(
      title: 'Pick One!',
      subtitle: _buildSubtitle(context),
    );
  }

  Widget _buildSubtitle(BuildContext context) {
    final colors = context.colors;
    final loading = notifier.isLoading || notifier.isSearching;
    return Column(
      children: [
        if (!loading) ...[
          Container(
            padding: kPadding4.add(kEdgePadding24),
            decoration: BoxDecoration(
              color: colors.primaryContainer,
              borderRadius: kBorderRadius22,
            ),
            child: Text(
              'OR',
              style: PuzzleTextStyle.bodySmall.copyWith(
                color: colors.primary,
              ),
            ),
          ),
          kBox8,
        ],
        ClipRect(
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: kPadding8,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              switchInCurve: Curves.easeInOut,
              switchOutCurve: Curves.easeInOut,
              transitionBuilder: (child, animation) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 1),
                    end: Offset.zero,
                  ).animate(animation),
                  child: AnimatedSwitcher.defaultTransitionBuilder(
                    child,
                    animation,
                  ),
                );
              },
              child: loading
                  ? Center(
                      child: RefreshProgressIndicator(
                        strokeWidth: 2,
                        color: colors.primaryContainer,
                        valueColor: AlwaysStoppedAnimation(colors.primary),
                        backgroundColor: colors.surfaceVariant,
                      ),
                    )
                  : SearchField(
                      onSubmitted: (term) async {
                        final imageData = await notifier.onSearch(term);
                        if (imageData != null) {
                          // ignore: use_build_context_synchronously
                          context.pushNamed(
                            RouteNames.picturesPuzzle,
                            extra: imageData,
                            queryParams: {'term': term},
                          );
                        }
                      },
                    ),
            ),
          ),
        ),
      ],
    );
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
      final imageData = await notifier.pickImage(source);
      if (imageData != null) {
        // ignore: use_build_context_synchronously
        context.pushNamed(RouteNames.picturesPuzzle, extra: imageData);
      }
    }

    final stopInteraction = notifier.isLoading || notifier.isSearching;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Tooltip(
          waitDuration: const Duration(seconds: 1),
          message: 'Choose your own picture',
          child: SquareButton(
            borderRadius: 8,
            color: colors.primary,
            onTap: stopInteraction ? null : () => _onTap(context, ImageSource.gallery),
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
            onTap: stopInteraction
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
