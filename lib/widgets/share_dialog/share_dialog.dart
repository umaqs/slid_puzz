import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slide_puzzle/audio/audio.dart';
import 'package:slide_puzzle/layout/layout.dart';

import 'puzzle_score.dart';
import 'share_dialog_animated_builder.dart';
import 'share_your_score.dart';

class ShareDialog extends StatefulWidget {
  const ShareDialog({
    Key? key,
    required this.screenshot,
  }) : super(key: key);

  final Uint8List screenshot;

  @override
  State<ShareDialog> createState() => _ShareDialogState();
}

class _ShareDialogState extends State<ShareDialog> with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    unawaited(context.read<AudioNotifier>().play(AudioAssets.success));

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    Future.delayed(
      const Duration(milliseconds: 140),
      _controller.forward,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      small: (_, child) => child!,
      medium: (_, child) => child!,
      large: (_, child) => child!,
      child: (layoutSize, _) {
        final padding = layoutSize == ResponsiveLayoutSize.large
            ? const EdgeInsets.fromLTRB(68, 82, 68, 73)
            : (layoutSize == ResponsiveLayoutSize.medium
                ? const EdgeInsets.fromLTRB(48, 54, 48, 53)
                : const EdgeInsets.fromLTRB(20, 99, 20, 76));

        final closeButtonOffset = layoutSize.isSmall ? 8.0 : 12.0;
        final crossAxisAlignment = layoutSize.isLarge ? CrossAxisAlignment.start : CrossAxisAlignment.center;

        return Stack(
          children: [
            SingleChildScrollView(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SizedBox(
                    width: constraints.maxWidth,
                    child: Padding(
                      padding: padding,
                      child: ShareDialogAnimatedBuilder(
                        animation: _controller,
                        builder: (context, child, animation) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: crossAxisAlignment,
                            children: [
                              SlideTransition(
                                position: animation.scoreOffset,
                                child: Opacity(
                                  opacity: animation.scoreOpacity.value,
                                  child: PuzzleScore(screenshot: widget.screenshot),
                                ),
                              ),
                              const ResponsiveGap(
                                small: 40,
                                medium: 40,
                                large: 80,
                              ),
                              ShareYourScore(
                                animation: animation,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              right: closeButtonOffset,
              top: closeButtonOffset,
              child: SafeArea(
                child: CloseButton(
                  onPressed: () {
                    unawaited(context.read<AudioNotifier>().play(AudioAssets.click));
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
