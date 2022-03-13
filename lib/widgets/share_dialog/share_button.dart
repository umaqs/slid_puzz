import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slide_puzzle/audio/audio.dart';
import 'package:slide_puzzle/helpers/helpers.dart';
import 'package:slide_puzzle/layout/responsive_layout_size.dart';
import 'package:slide_puzzle/typography/typography.dart';

const _shareUrl = 'https://slidpuzz.web.app/';
const _shareText = 'Just solved the #FlutterPuzzleHack! Check it out ↓';

class TwitterButton extends StatelessWidget {
  const TwitterButton({Key? key}) : super(key: key);

  String _twitterShareUrl(BuildContext context) {
    final encodedShareText = Uri.encodeComponent(_shareText);
    return 'https://twitter.com/intent/tweet?url=$_shareUrl&text=$encodedShareText';
  }

  @override
  Widget build(BuildContext context) {
    return ShareButton(
      title: 'Twitter',
      icon: Image.asset(
        'assets/images/twitter_icon.png',
        width: 13.13,
        height: 10.67,
      ),
      color: const Color(0xFF13B9FD),
      onPressed: () => openLink(_twitterShareUrl(context)),
    );
  }
}

class FacebookButton extends StatelessWidget {
  const FacebookButton({Key? key}) : super(key: key);

  String _facebookShareUrl(BuildContext context) {
    final encodedShareText = Uri.encodeComponent(_shareText);
    return 'https://www.facebook.com/sharer.php?u=$_shareUrl&quote=$encodedShareText';
  }

  @override
  Widget build(BuildContext context) {
    return ShareButton(
      title: 'Facebook',
      icon: Image.asset(
        'assets/images/facebook_icon.png',
        width: 6.56,
        height: 13.13,
      ),
      color: const Color(0xFF0468D7),
      onPressed: () => openLink(_facebookShareUrl(context)),
    );
  }
}

class ShareButton extends StatelessWidget {
  const ShareButton({
    Key? key,
    required this.onPressed,
    required this.title,
    required this.icon,
    required this.color,
  }) : super(key: key);

  final VoidCallback onPressed;
  final String title;
  final Widget icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        border: Border.all(color: color),
        borderRadius: kBorderRadius8,
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          primary: color,
          shape: RoundedRectangleBorder(
            borderRadius: kBorderRadius8,
          ),
          backgroundColor: Colors.transparent,
        ),
        onPressed: () async {
          onPressed();
          unawaited(context.read<AudioNotifier>().play(AudioAssets.click));
        },
        child: Row(
          children: [
            kBox12,
            ClipRRect(
              borderRadius: kBorderRadius8,
              child: Container(
                alignment: Alignment.center,
                width: 32,
                height: 32,
                color: color,
                child: icon,
              ),
            ),
            kBox12,
            Text(
              title,
              style: PuzzleTextStyle.headline5.copyWith(
                color: color,
              ),
            ),
            kBox24,
          ],
        ),
      ),
    );
  }
}
