import 'package:flutter/material.dart';
import 'package:hexagon/hexagon.dart';
import 'package:provider/provider.dart';
import 'package:slide_puzzle/audio/audio.dart';
import 'package:slide_puzzle/layout/layout.dart';
import 'package:slide_puzzle/themes/themes.dart';
import 'package:slide_puzzle/widgets/animations/animated_hover_interaction.dart';

class AudioControl extends StatelessWidget {
  const AudioControl({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      small: (_, child) => child!,
      medium: (_, child) => child!,
      large: (_, child) => child!,
      child: (layoutSize, constraints) {
        final colors = context.watch<ThemeNotifier>().currentColor.theme.colorScheme;

        final notifier = context.watch<AudioNotifier>();
        final audioMuted = notifier.isMuted;

        return AnimatedHoverInteraction(
          child: HexagonWidget.flat(
            inBounds: false,
            elevation: 12,
            color: colors.primary,
            cornerRadius: 8,
            width: layoutSize.hexTileWidth * 0.9,
            child: SizedBox.expand(
              child: GestureDetector(
                onTap: notifier.toggleSound,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        color: Colors.transparent,
                        alignment: Alignment.center,
                        child: Icon(
                          audioMuted ? Icons.volume_off : Icons.volume_up,
                          size: 36,
                          color: colors.surface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
