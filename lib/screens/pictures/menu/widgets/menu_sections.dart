import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:slide_puzzle/app/app.dart';
import 'package:slide_puzzle/layout/layout.dart';
import 'package:slide_puzzle/screens/pictures/menu/menu.dart';
import 'package:slide_puzzle/screens/pictures/puzzle/puzzle.dart';
import 'package:slide_puzzle/services/snackbar.service.dart';
import 'package:slide_puzzle/themes/themes.dart';
import 'package:slide_puzzle/widgets/widgets.dart';

class MenuFooter extends StatelessWidget {
  const MenuFooter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      small: (_, child) => child!,
      medium: (_, child) => child!,
      large: (_, child) => SizedBox(
        height: ResponsiveLayoutSize.large.squareBoardSize,
        child: child!,
      ),
      child: (layoutSize, _) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const ResponsiveGap(
              small: 32,
              medium: 48,
            ),
            _MenuButtons(),
            const ResponsiveGap(
              small: 32,
              medium: 48,
            ),
          ],
        );
      },
    );
  }
}

class _MenuButtons extends StatelessWidget {
  const _MenuButtons({
    Key? key,
  }) : super(key: key);

  Future<void> _onTap(BuildContext context, ImageSource source) async {
    final notifier = context.read<PicturesMenuNotifier>();
    final imageParts = await notifier.pickImage(source);
    if (imageParts != null) {
      AppNavigator.of(context)?.push(
        PicturesPuzzleScreen.buildPage(
          context,
          imageParts,
        ),
      );
    } else {
      final error = notifier.error;
      if (error != null) {
        SnackBarService.instance.showSnackBar(message: error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final notifier = context.watch<PicturesMenuNotifier>();

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
        ResponsiveGap(
          small: 8,
          medium: 12,
          large: 16,
        ),
        Tooltip(
          waitDuration: const Duration(seconds: 1),
          message: 'Refresh images',
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
