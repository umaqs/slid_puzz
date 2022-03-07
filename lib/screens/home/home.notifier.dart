import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hexagon/hexagon.dart';
import 'package:slide_puzzle/app/app.dart';
import 'package:slide_puzzle/screens/_base/base.notifier.dart';

class HexMenuItem {
  HexMenuItem({
    required this.index,
    required this.icon,
    required this.label,
    required this.modeToolTip,
    required this.coordinates,
  });

  final int index;
  final IconData icon;
  final String label;
  final String modeToolTip;
  final Coordinates coordinates;

  Offset get offset {
    final q = coordinates.q;
    final r = coordinates.r;
    final x = q * sqrt(3) + r * sqrt(3) / 2;
    final y = r * 3 / 2.0;
    return Offset(x, y);
  }
}

class HomeNotifier extends BaseNotifier {
  HomeNotifier()
      : _menuItems = [
          HexMenuItem(
            index: 0,
            icon: Icons.apps,
            label: 'Numbers',
            modeToolTip: 'Numbers Square Grid',
            coordinates: Coordinates.axial(0, -1),
          ),
          HexMenuItem(
            index: 1,
            icon: Icons.hexagon,
            label: 'Numbers',
            modeToolTip: 'Numbers Hex Grid',
            coordinates: Coordinates.axial(1, -1),
          ),
          HexMenuItem(
            index: 2,
            icon: Icons.apps,
            label: 'Words',
            modeToolTip: 'Words Square Grid',
            coordinates: Coordinates.axial(-1, 0),
          ),
          HexMenuItem(
            index: 3,
            icon: Icons.image,
            label: 'Pictures',
            modeToolTip: 'Pictures',
            coordinates: Coordinates.axial(0, 0),
          ),
          HexMenuItem(
            index: 4,
            icon: Icons.hexagon,
            label: 'Words',
            modeToolTip: 'Words Hex Grid',
            coordinates: Coordinates.axial(1, 0),
          ),
          HexMenuItem(
            index: 5,
            icon: Icons.color_lens,
            label: 'Themes',
            modeToolTip: 'Select a theme',
            coordinates: Coordinates.axial(-1, 1),
          ),
          HexMenuItem(
            index: 6,
            icon: Icons.help,
            label: 'Help',
            modeToolTip: 'Learn the rules',
            coordinates: Coordinates.axial(0, 1),
          ),
        ];

  List<HexMenuItem> get menuItems => _menuItems;
  final List<HexMenuItem> _menuItems;

  void itemTapped(BuildContext context, HexMenuItem menuItem) {
    switch (menuItem.index) {
      case 0:
        _navigateTo(context, RouteNames.numbersSquare);
        break;
      case 1:
        _navigateTo(context, RouteNames.numbersHex);
        break;
      case 2:
        _navigateTo(context, RouteNames.wordsSquare);
        break;
      case 3:
        _navigateTo(context, RouteNames.picturesMenu);
        break;
      case 4:
        _navigateTo(context, RouteNames.wordsHex);
        break;
      case 5:
        _navigateTo(context, RouteNames.themes);
        break;
    }
  }

  void _navigateTo(BuildContext context, String name) {
    context.pushNamed(name);
  }
}
