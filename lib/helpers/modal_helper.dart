import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:slide_puzzle/game/_shared/shared.dart';
import 'package:slide_puzzle/widgets/widgets.dart';

Future<T?> showAppDialog<T>({
  required BuildContext context,
  required Widget child,
  bool barrierDismissible = true,
  String barrierLabel = '',
}) {
  return showGeneralDialog<T>(
    transitionBuilder: (context, animation, secondaryAnimation, widget) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeIn,
      );

      return ScaleTransition(
        scale: Tween<double>(begin: 0.5, end: 1).animate(curvedAnimation),
        child: FadeTransition(
          opacity: curvedAnimation,
          child: widget,
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 500),
    barrierDismissible: barrierDismissible,
    barrierLabel: barrierLabel,
    barrierColor: const Color(0x66000000),
    context: context,
    pageBuilder: (context, animation, secondaryAnimation) => AppDialog(
      child: child,
    ),
  );
}

Future<void> showGameCompletedDialog(BuildContext context, GlobalKey boardKey) async {
  final puzzleNotifier = context.read<PuzzleGameNotifier>();
  final timerNotifier = context.read<GameTimerNotifier>();

  final boundary = boardKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
  if (boundary == null) {
    return;
  }

  final screenshot = await boundary
      .toImage()
      .then((image) => image.toByteData(format: ImageByteFormat.png))
      .then((data) => data == null ? null : data.buffer.asUint8List());

  if (screenshot == null) {
    return;
  }

  await showAppDialog<void>(
    context: context,
    barrierDismissible: true,
    child: MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: puzzleNotifier),
        ChangeNotifierProvider.value(value: timerNotifier),
      ],
      child: ShareDialog(screenshot: screenshot),
    ),
  );
}
