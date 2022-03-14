import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:slide_puzzle/services/snackbar.service.dart';
import 'package:url_launcher/url_launcher.dart';

class ShareService {
  const ShareService();

  Future<void> openLink(String url, {VoidCallback? onError}) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else if (onError != null) {
      onError();
    }
  }

  Future<void> share(BuildContext context, {required String text, Uint8List? image}) async {
    final box = context.findRenderObject() as RenderBox?;
    final position = box!.localToGlobal(Offset.zero) & box.size;

    if (image == null || kIsWeb) {
      return Share.share(text, sharePositionOrigin: position);
    } else {
      try {
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/screenshot.png');
        await file.writeAsBytes(image);

        await Share.shareFiles(
          [file.path],
          text: text,
          sharePositionOrigin: position,
        );

        await file.delete();
      } catch (_) {
        SnackBarService.instance.showSnackBar(message: 'Unable to share, please try again!');
      }
    }
  }
}
