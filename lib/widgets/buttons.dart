import 'package:flutter/material.dart';
import 'package:slide_puzzle/layout/layout.dart';
import 'package:slide_puzzle/themes/themes.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    Key? key,
    required this.text,
    this.onPressed,
  }) : super(key: key);

  final String text;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      small: (_, child) => child!,
      medium: (_, child) => child!,
      large: (_, child) => child!,
      child: (layoutSize, _) {
        final theme = context.theme;

        final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
          textStyle: theme.textTheme.headline2?.copyWith(
            fontSize: layoutSize.buttonFontSize,
          ),
          padding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: kBorderRadius12,
          ),
        );
        return ElevatedButton(
          style: raisedButtonStyle,
          onPressed: onPressed,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(text.toUpperCase()),
          ),
        );
      },
    );
  }
}

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    Key? key,
    required this.text,
    this.onPressed,
  }) : super(key: key);

  final String text;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      small: (_, child) => child!,
      medium: (_, child) => child!,
      large: (_, child) => child!,
      child: (layoutSize, _) {
        final theme = context.theme;

        final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
          primary: theme.colorScheme.secondary,
          onPrimary: theme.colorScheme.onSecondary,
          textStyle: theme.textTheme.headline2?.copyWith(
            fontSize: layoutSize.buttonFontSize,
          ),
          padding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: kBorderRadius12,
          ),
        );
        return ElevatedButton(
          style: raisedButtonStyle,
          onPressed: onPressed,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(text.toUpperCase()),
          ),
        );
      },
    );
  }
}
