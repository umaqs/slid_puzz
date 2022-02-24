import 'dart:math';

extension ListExtensions<T> on Iterable<T> {
  T getRandom([Random? seed]) {
    final list = [...this].toList()..shuffle(seed);
    return list.first;
  }
}
