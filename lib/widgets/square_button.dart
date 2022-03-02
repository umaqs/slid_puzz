import 'package:flutter/material.dart';
import 'package:slide_puzzle/layout/layout.dart';
import 'package:slide_puzzle/themes/themes.dart';
import 'package:slide_puzzle/widgets/widgets.dart';

class SquareButton extends StatelessWidget {
  const SquareButton({
    Key? key,
    this.color,
    this.gradient,
    this.elevation = 0,
    this.tilt = true,
    this.borderRadius,
    this.borderColor,
    this.borderWidth,
    this.disableShadows = false,
    this.onTap,
    this.child,
  })  : assert(color == null || gradient == null, 'Cannot provide both a color and a gradient\n'),
        super(key: key);

  final Color? color;
  final Gradient? gradient;
  final Color? borderColor;
  final double? borderWidth;
  final double elevation;
  final bool tilt;
  final double? borderRadius;
  final bool disableShadows;
  final VoidCallback? onTap;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ResponsiveLayoutBuilder(
        small: (_, child) => child!,
        medium: (_, child) => child!,
        large: (_, child) => child!,
        child: (layoutSize, _) {
          final shadowOffset = 2.0;
          return AnimatedHoverInteraction(
            enabled: onTap != null,
            tilt: tilt,
            scale: false,
            child: AnimatedContainer(
              width: layoutSize.squareTileSize,
              height: layoutSize.squareTileSize,
              duration: const Duration(milliseconds: 300),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: color ?? context.colors.surface,
                gradient: gradient,
                boxShadow: disableShadows
                    ? []
                    : [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.08),
                          blurRadius: elevation,
                          offset: Offset(-shadowOffset, -shadowOffset),
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: elevation,
                          offset: Offset(shadowOffset, shadowOffset),
                        ),
                      ],
                borderRadius: borderRadius != null ? BorderRadius.circular(borderRadius!) : null,
                border: Border.fromBorderSide(
                  borderColor != null
                      ? BorderSide(
                          width: borderWidth ?? 4,
                          color: borderColor!,
                        )
                      : BorderSide.none,
                ),
              ),
              child: child,
            ),
          );
        },
      ),
    );
  }
}
