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
    final colors = context.colors;

    Text buildText(int index) => Text(
          _difficultyText(index),
          style: TextStyle(
            color: colors.onSecondaryContainer,
          ),
        );

    return Material(
      color: colors.secondaryContainer,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: kEdgePadding8.add(kPadding4),
        child: DropdownButton<int>(
          isExpanded: true,
          value: initialValue,
          borderRadius: kBorderRadius12,
          underline: const SizedBox.shrink(),
          focusColor: Colors.transparent,
          onChanged: (value) => onChanged?.call(value ?? initialValue),
          selectedItemBuilder: (context) {
            return [
              for (var i = min; i <= max; i++)
                Align(
                  alignment: Alignment.centerLeft,
                  child: buildText(i),
                ),
            ];
          },
          items: [
            for (var i = min; i <= max; i++)
              DropdownMenuItem<int>(
                value: i,
                alignment: Alignment.centerLeft,
                child: buildText(i),
              ),
          ],
        ),
      ),
    );
  }
}
