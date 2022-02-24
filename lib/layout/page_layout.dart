import 'package:flutter/material.dart';
import 'package:slide_puzzle/layout/layout.dart';

class PageLayout extends StatelessWidget {
  const PageLayout({
    Key? key,
    required this.layoutBuilderDelegate,
  }) : super(key: key);

  final PageLayoutDelegate layoutBuilderDelegate;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ResponsiveLayoutBuilder(
        small: (_, child) => child!,
        medium: (_, child) => child!,
        large: _buildLarge,
        child: (layoutSize, constraints) {
          if (layoutSize.isLarge) {
            return const SizedBox.shrink();
          }
          return _buildMediumAndSmall(context, constraints);
        },
      ),
    );
  }

  Widget _buildLarge(BuildContext context, Widget? child) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(child: LayoutBuilder(builder: layoutBuilderDelegate.startSection)),
        Flexible(
          flex: 2,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: LayoutBuilder(builder: layoutBuilderDelegate.body),
          ),
        ),
        Expanded(child: LayoutBuilder(builder: layoutBuilderDelegate.endSection)),
      ],
    );
  }

  Widget _buildMediumAndSmall(BuildContext context, BoxConstraints constraints) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: constraints.maxHeight,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            LayoutBuilder(builder: layoutBuilderDelegate.startSection),
            kBox8,
            FittedBox(
              fit: BoxFit.scaleDown,
              child: LayoutBuilder(
                builder: layoutBuilderDelegate.body,
              ),
            ),
            kBox8,
            LayoutBuilder(builder: layoutBuilderDelegate.endSection),
          ],
        ),
      ),
    );
  }
}
