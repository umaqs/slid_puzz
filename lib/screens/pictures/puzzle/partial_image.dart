import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class PartialImage extends StatelessWidget {
  const PartialImage({
    Key? key,
    required this.gridSize,
    required this.image,
    required this.offset,
  }) : super(key: key);

  final int gridSize;
  final ui.Image image;
  final Offset offset;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _PartialImagePainter(
        gridSize: gridSize,
        image: image,
        offset: offset,
      ),
    );
  }
}

class _PartialImagePainter extends CustomPainter {
  const _PartialImagePainter({
    required this.offset,
    required this.image,
    required this.gridSize,
  });

  final Offset offset;
  final ui.Image image;
  final int gridSize;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    final width = image.width / gridSize;
    final height = image.height / gridSize;
    final tileSize = min(width, height);
    final srcOffset = offset * tileSize;

    final src = Rect.fromLTWH(srcOffset.dx, srcOffset.dy, tileSize, tileSize);
    final dst = Rect.fromLTWH(0, 0, size.width, size.height);

    canvas.drawImageRect(image, src, dst, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
