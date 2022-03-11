import 'package:flutter/material.dart';
import 'package:slide_puzzle/layout/layout.dart';
import 'package:slide_puzzle/themes/themes.dart';
import 'package:slide_puzzle/typography/typography.dart';

class SearchField extends StatefulWidget {
  const SearchField({
    Key? key,
    required this.onSubmitted,
  }) : super(key: key);

  final ValueChanged<String> onSubmitted;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  bool get hasFocus => _focusNode.hasFocus;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final decorationColor = hasFocus ? colors.primary : colors.secondary;
    final labelStyle = PuzzleTextStyle.label.copyWith(
      color: decorationColor,
      height: 1,
    );

    final border = OutlineInputBorder(
      borderRadius: kBorderRadius8,
      borderSide: BorderSide(
        color: decorationColor,
        width: hasFocus ? 3 : 1,
      ),
    );

    return SizedBox(
      height: kTextTabBarHeight,
      width: context.layoutSize.squareBoardSize,
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        textInputAction: TextInputAction.search,
        style: PuzzleTextStyle.bodySmall.copyWith(
          color: colors.primary,
          height: 1,
        ),
        onSubmitted: (value) {
          if (value.isEmpty) return;
          _controller.clear();
          widget.onSubmitted(value);
        },
        decoration: InputDecoration(
          labelText: 'Search from unsplash',
          hoverColor: colors.secondaryContainer,
          labelStyle: labelStyle,
          floatingLabelStyle: labelStyle,
          border: border,
          enabledBorder: border,
          floatingLabelAlignment: FloatingLabelAlignment.center,
          prefixIcon: Icon(Icons.search, color: decorationColor),
        ),
      ),
    );
  }
}
