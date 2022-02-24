import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'circular_reveal_clipper.dart';

class ScaleTransitionPage extends CustomTransitionPage<void> {
  ScaleTransitionPage({
    required LocalKey key,
    required Widget child,
  }) : super(
          key: key,
          transitionsBuilder: _buildTransitionBuilder,
          transitionDuration: const Duration(milliseconds: 500),
          child: child,
        );
}

Widget _buildTransitionBuilder(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return ClipPath(
    clipper: CircularRevealClipper(
      fraction: CurveTween(curve: Curves.easeInOut).evaluate(animation),
      alignment: Alignment.center,
    ),
    child: child,
  );
}
