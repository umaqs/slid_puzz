import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:slide_puzzle/helpers/helpers.dart';
import 'package:slide_puzzle/layout/responsive_layout_size.dart';
import 'package:slide_puzzle/services/share.service.dart';
import 'package:slide_puzzle/themes/themes.dart';
import 'package:slide_puzzle/widgets/square_button.dart';

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
      onTap: () => openLink(_twitterShareUrl(context)),
      color: const Color(0xFFFFFFFF),
      backgroundColor: const Color(0xFF13B9FD),
      icon: FontAwesomeIcons.twitter,
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
      onTap: () => openLink(_facebookShareUrl(context)),
      color: const Color(0xFFFFFFFF),
      backgroundColor: const Color(0xFF0468D7),
      icon: FontAwesomeIcons.facebookF,
    );
  }
}

class ShareImageButton extends StatelessWidget {
  const ShareImageButton({
    Key? key,
    required this.imageData,
  }) : super(key: key);

  final Uint8List? imageData;

  Future<void> _onTap(BuildContext context) async {
    const text = '$_shareText\n$_shareUrl';
    final shareService = context.read<ShareService>();
    shareService.share(context, text: text, image: imageData);
  }

  @override
  Widget build(BuildContext context) {
    return ShareButton(
      onTap: () => _onTap(context),
      color: context.colors.onPrimary,
      backgroundColor: context.colors.primary,
      icon: Icons.share,
    );
  }
}

class ShareButton extends StatelessWidget {
  const ShareButton({
    Key? key,
    required this.onTap,
    required this.icon,
    required this.color,
    required this.backgroundColor,
  }) : super(key: key);

  final VoidCallback onTap;
  final IconData icon;
  final Color color;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: context.layoutSize.squareTileSize * 0.6,
      child: SquareButton(
        onTap: onTap,
        color: backgroundColor,
        elevation: 100,
        borderRadius: 100,
        child: Icon(icon, color: color),
      ),
    );
  }
}
