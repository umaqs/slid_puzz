import 'package:flutter/material.dart';
import 'package:slide_puzzle/screens/_base/base.notifier.dart';

abstract class PageLayoutDelegate<T extends BaseNotifier> {
  T get notifier;

  Widget startSection(BuildContext context, BoxConstraints constraints);
  Widget body(BuildContext context, BoxConstraints constraints);
  Widget endSection(BuildContext context, BoxConstraints constraints);
  Widget gridItem(BuildContext context, int index);
}
