import 'dart:math';

import 'package:flutter/material.dart';

class TileAnimation extends StatefulWidget {
  const TileAnimation({
    Key? key,
    required this.offset,
    required this.duration,
    required this.child,
  }) : super(key: key);

  final FractionalOffset offset;
  final Duration duration;
  final Widget child;

  @override
  _TileAnimationState createState() => _TileAnimationState();
}

class _TileAnimationState extends State<TileAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late FractionalOffset _oldOffset;

  @override
  void initState() {
    super.initState();
    _oldOffset = widget.offset;
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    const midValue = 0.0;
    _animation = TweenSequence<double>(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.0, end: midValue).chain(
            CurveTween(
              curve: Curves.easeIn,
            ),
          ),
          weight: 40.0,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: midValue, end: 1.0).chain(
            CurveTween(
              curve: Curves.easeOut,
            ),
          ),
          weight: 40.0,
        ),
      ],
    ).animate(_controller);

    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant TileAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.offset != oldWidget.offset) {
      _oldOffset = oldWidget.offset;
      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final newOffset = widget.offset;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final rotationFactor = pi * (1 - _animation.value);
        return AlignTransition(
          alignment: Tween<FractionalOffset>(
            begin: _oldOffset,
            end: newOffset,
          ).animate(_controller),
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..rotateX((newOffset.dy - _oldOffset.dy) * rotationFactor)
              ..rotateY((newOffset.dx - _oldOffset.dx) * rotationFactor)
              ..setEntry(3, 2, 0.005),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}
