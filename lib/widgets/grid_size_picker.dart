import 'package:flutter/material.dart';
import 'package:slide_puzzle/layout/layout.dart';
import 'package:slide_puzzle/themes/themes.dart';

class GridSizePicker extends StatelessWidget {
  const GridSizePicker({
    Key? key,
    required this.initialValue,
    required this.min,
    required this.max,
    this.onChanged,
    this.padding,
  }) : super(key: key);

  final int initialValue;
  final int min;
  final int max;
  final ValueChanged<int>? onChanged;
  final EdgeInsets? padding;

  String _difficultyText(int index) {
    final level = index - min;

    final levels = {
      0: 'Easy',
      1: 'Medium',
      2: 'Difficult',
      3: 'Inferno',
    };

    if (levels.containsKey(level)) {
      return levels[level]!;
    }

    throw 'Invalid level $level';
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      isExpanded: true,
      value: initialValue,
      borderRadius: kBorderRadius12,
      underline: Container(
        height: 2,
        color: context.colors.primary,
      ),
      focusColor: Colors.transparent,
      onChanged: (value) => onChanged?.call(value ?? initialValue),
      selectedItemBuilder: (context) {
        return [
          for (var i = min; i <= max; i++)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Text('Level'),
                Text(_difficultyText(i)),
              ],
            ),
        ];
      },
      items: [
        for (var i = min; i <= max; i++)
          DropdownMenuItem<int>(
            value: i,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_difficultyText(i)),
              ],
            ),
          ),
      ],
    );
  }
}
