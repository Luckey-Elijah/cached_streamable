// ignore_for_file: avoid_print

import 'package:cached_streamable/cached_streamable.dart';

class CounterRepository extends CachedStreamable<int> {
  CounterRepository() : super(0);

  // Some arbitrary future that updates the internal cache
  Future<void> increment() =>
      Future<void>.delayed(Duration.zero, () => cache = cache + 1);

  int get value => cache;
}

Future<void> main() async {
  final counter = CounterRepository()..stream.listen(print);

  // prints "1"
  await counter.increment();

  /// don't forget to close
  await counter.close();
}
