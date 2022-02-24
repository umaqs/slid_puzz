import 'package:flutter/material.dart';

class ModeView extends StatelessWidget {
  const ModeView({
    Key? key,
    required this.child,
    this.appbarTitle,
    this.actions,
  }) : super(key: key);

  final Widget? appbarTitle;
  final Widget child;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (appbarTitle != null)
          AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            title: appbarTitle,
            actions: actions,
          ),
        Expanded(child: child),
      ],
    );
  }
}
