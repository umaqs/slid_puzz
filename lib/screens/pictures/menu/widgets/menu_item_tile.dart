import 'dart:math';

import 'package:flutter/material.dart';
import 'package:slide_puzzle/screens/pictures/menu/menu_item.dart';
import 'package:slide_puzzle/themes/themes.dart';
import 'package:slide_puzzle/widgets/widgets.dart';

class MenuItemTile extends StatelessWidget {
  const MenuItemTile({
    Key? key,
    required this.item,
    required this.isLoading,
    this.onTap,
  }) : super(key: key);

  final MenuItem item;

  final bool isLoading;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return isLoading || item.data == null
        ? _MenuItemTileLoader(item: item)
        : SquareButton(
            color: Colors.transparent,
            borderRadius: 8,
            onTap: onTap,
            child: Image.memory(item.data!),
          );
  }
}

class _MenuItemTileLoader extends StatefulWidget {
  const _MenuItemTileLoader({
    Key? key,
    required this.item,
  }) : super(key: key);

  final MenuItem item;

  @override
  _MenuItemTileLoaderState createState() => _MenuItemTileLoaderState();
}

class _MenuItemTileLoaderState extends State<_MenuItemTileLoader> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _initAnimation();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _initAnimation() {
    final direction = Random().nextInt(3).toDouble();
    final offset = Offset.fromDirection(direction * pi / 2);

    _offsetAnimation = Tween<Offset>(
      begin: offset,
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.bounceOut,
        reverseCurve: Curves.easeInBack,
      ),
    );

    _animationController.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    final showImage = widget.item.data != null && Random().nextBool();

    return Material(
      type: MaterialType.transparency,
      clipBehavior: Clip.hardEdge,
      child: SlideTransition(
        position: _offsetAnimation,
        child: SquareButton(
          gradient: context.getMenuLoaderGradient(seed: widget.item.key),
          borderRadius: 8,
          child: showImage
              ? Image.memory(
                  widget.item.data!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, dynamic ___) => const SizedBox.shrink(),
                )
              : null,
        ),
      ),
    );
  }
}
