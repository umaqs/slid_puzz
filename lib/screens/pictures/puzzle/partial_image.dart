import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class PartialImage extends StatelessWidget {
  const PartialImage({
    Key? key,
    required this.gridSize,
    required this.image,
    required this.offset,
    required this.margin,
  }) : super(key: key);

  final int gridSize;
  final ui.Image image;
  final Offset offset;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _PartialImagePainter(
        gridSize: gridSize,
        image: image,
        offset: offset,
        margin: margin,
      ),
    );
  }
}

class _PartialImagePainter extends CustomPainter {
  const _PartialImagePainter({
    required this.offset,
    required this.image,
    required this.gridSize,
    required this.margin,
  });

  final Offset offset;
  final ui.Image image;
  final int gridSize;
  final EdgeInsetsGeometry margin;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    final width = image.width / gridSize;
    final height = image.height / gridSize;
    final tileSize = min(width, height);
    final srcOffset = offset * tileSize;

    final dx = margin.horizontal * 0.5;
    final dy = margin.vertical * 0.5;

    final src = Rect.fromLTWH(srcOffset.dx + dx, srcOffset.dy + dy, tileSize - dx, tileSize - dy);
    final dst = Rect.fromLTWH(0, 0, size.width, size.height);

    canvas.drawImageRect(image, src, dst, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
