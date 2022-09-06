import 'dart:io';

import 'package:cached_streamable/cached_streamable.dart';

class OtherCounter extends CachedStreamable<int> {
  OtherCounter() : super(0);

  Future<void> increment() =>
      Future<void>.delayed(Duration.zero, () => value = value + 1);
}

/// prints:
/// ```
/// otherCounter: 0
/// counter: 0
/// otherCounter: 1
/// counter: 1
/// ```
Future<void> main() async {
  final otherCounter = OtherCounter();
  final counter = CachedStreamable<int>(
    0,
    // ensures only incrementing the value
    updateWhen: (oldValue, newValue) => oldValue < newValue,
  );

  // listening will print the current value - "0"
  otherCounter.stream.listen((value) => stdout.writeln('otherCounter: $value'));
  counter.stream.listen((value) => stdout.writeln('counter: $value'));

  // prints "1"
  await otherCounter.increment();
  counter.value++;

  /// don't forget to close
  await otherCounter.close();
  await counter.close();
}
