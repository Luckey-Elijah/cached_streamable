# `cached_streamable`

Simple interface for creating a streamable data source that caches it latest value.

*Think of it as an "extended" `StreamController`.*

[![MIT license](https://img.shields.io/badge/license-MIT-blue)](https://opensource.org/licenses/MIT)
[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]

## Usage

1. Create your implementation by extending `CachedStreamable`.
Use the `value` getter and setter to update the cached value.
You can use any single data type. This example uses `int`.
(`value` getter is where you can access the latest data.
`value` setter is where you can update the cache and notify listeners.)

```dart
class CounterRepository extends CachedStreamable<int> {
  CounterRepository() : super(0);

  // Some arbitrary future that updates the internal cached value
  Future<void> increment() =>
      Future<void>.delayed(Duration.zero, () => value = value + 1);
}
```

2. Use the `stream` to access all the updates to the cache.

```dart
Future<void> main() async {
  // prints "0" when first listened to
  final repo = CounterRepository()..stream.listen(print);

  // prints "1"
  await repo.increment();
}
```

3. Don't forget to call `close` when you are done.

```dart
await repo.close();
```

You don't have to extend the class. You can use `CachedStreamable` inline:

```dart
final counter = CachedStreamable<int>(0);
counter.value++;
```

[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
