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
    _focusNode.addListener(_setState);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_setState);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _setState() {
    setState(() {});
  }

  bool get hasFocus => _focusNode.hasFocus;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final decorationColor = hasFocus || context.theme.brightness.isLight ? colors.primary : colors.tertiary;
    final labelStyle = PuzzleTextStyle.bodySmall.copyWith(
      color: decorationColor,
      height: hasFocus ? null : 1,
    );

    final border = OutlineInputBorder(
      borderRadius: kBorderRadius8,
      borderSide: BorderSide(
        color: decorationColor,
        width: hasFocus ? 3 : 2,
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
          labelText: 'Search',
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
