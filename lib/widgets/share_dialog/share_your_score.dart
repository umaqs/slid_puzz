import 'package:flutter/material.dart';
import 'package:slide_puzzle/layout/layout.dart';
import 'package:slide_puzzle/themes/themes.dart';
import 'package:slide_puzzle/typography/typography.dart';

import 'share_button.dart';
import 'share_dialog_animated_builder.dart';

class ShareYourScore extends StatelessWidget {
  const ShareYourScore({
    Key? key,
    required this.animation,
  }) : super(key: key);

  final ShareDialogEnterAnimation animation;

  @override
  Widget build(BuildContext context) {
    final layoutSize = context.layoutSize;

    final titleTextStyle =
        layoutSize == ResponsiveLayoutSize.small ? PuzzleTextStyle.headline4 : PuzzleTextStyle.headline3;

    final messageTextStyle =
        layoutSize == ResponsiveLayoutSize.small ? PuzzleTextStyle.bodyXSmall : PuzzleTextStyle.bodySmall;

    final titleAndMessageCrossAxisAlignment =
        layoutSize == ResponsiveLayoutSize.large ? CrossAxisAlignment.start : CrossAxisAlignment.center;

    final textAlign = layoutSize == ResponsiveLayoutSize.large ? TextAlign.left : TextAlign.center;

    final messageWidth = layoutSize == ResponsiveLayoutSize.large
        ? double.infinity
        : (layoutSize == ResponsiveLayoutSize.medium ? 434.0 : 307.0);

    final buttonsMainAxisAlignment =
        layoutSize == ResponsiveLayoutSize.large ? MainAxisAlignment.start : MainAxisAlignment.center;

    final colors = context.colors;

    return Column(
      crossAxisAlignment: titleAndMessageCrossAxisAlignment,
      children: [
        SlideTransition(
          position: animation.shareYourScoreOffset,
          child: Opacity(
            opacity: animation.shareYourScoreOpacity.value,
            child: Column(
              crossAxisAlignment: titleAndMessageCrossAxisAlignment,
              children: [
                Text(
                  'Share your score!',
                  textAlign: textAlign,
                  style: titleTextStyle.copyWith(
                    color: colors.onSurface,
                  ),
                ),
                kBox16,
                SizedBox(
                  width: messageWidth,
                  child: Text(
                    'Share this puzzle to challenge your friends and family.',
                    textAlign: textAlign,
                    style: messageTextStyle.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const ResponsiveGap(
          small: 40,
          medium: 40,
          large: 24,
        ),
        SlideTransition(
          position: animation.socialButtonsOffset,
          child: Opacity(
            opacity: animation.socialButtonsOpacity.value,
            child: Row(
              mainAxisAlignment: buttonsMainAxisAlignment,
              children: const [
                TwitterButton(),
                kBox16,
                FacebookButton(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
