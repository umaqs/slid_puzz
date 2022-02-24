import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AnimatedHoverInteraction extends StatefulWidget {
  const AnimatedHoverInteraction({
    Key? key,
    this.enabled = true,
    this.tilt = false,
    this.scale = true,
    required this.child,
  }) : super(key: key);

  final bool enabled;
  final bool tilt;
  final bool scale;
  final Widget child;

  @override
  _AnimatedHoverInteractionState createState() => _AnimatedHoverInteractionState();
}

class _AnimatedHoverInteractionState extends State<AnimatedHoverInteraction> with SingleTickerProviderStateMixin {
  /// The controller that drives [_scale] animation.
  late AnimationController _controller;
  late Animation<double> _scale;

  // Rotations
  double x = 0, y = 0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    _scale = Tween<double>(begin: 1, end: 0.94).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 1, curve: Curves.easeInOut),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      return widget.child;
    }

    final scale = widget.scale ? _scale.value : 1.0;

    return MouseRegion(
      onHover: (details) {
        if (widget.enabled) {
          if (widget.tilt) {
            setState(() {
              x = 0.5 - details.localPosition.dy / 180;
              y = -0.5 + details.localPosition.dx / 180;
            });
          }
        }
      },
      onEnter: (_) {
        if (widget.enabled) {
          _controller.forward();
        }
      },
      onExit: (_) {
        if (widget.enabled) {
          _controller.reverse();
          if (widget.tilt) {
            setState(() {
              x = 0;
              y = 0;
            });
          }
        }
      },
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..scale(scale, scale)
          ..rotateY(y)
          ..rotateX(x)
          ..setEntry(3, 2, 0.001),
        child: ScaleTransition(
          scale: _scale,
          child: widget.child,
        ),
      ),
    );
  }
}
