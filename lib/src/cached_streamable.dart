import 'dart:async';

import 'package:meta/meta.dart';

/// {@template cached_streamable}
/// Make any data type streamable.
/// {@endtemplate}
/// This class should be extended.
///
/// **Example**
/// ```dart
/// class CounterRepository extends CachedStreamable<int> {
///   CounterRepository() : super(0);
///
///   Future<void> increment() =>
///     Future.delayed(Duration.zero, () => cache = cache + 1);
/// }
///
/// Future<void> main() async {
///   final counter = CounterRepository()..stream.listen(print); // 0
///   await counter.increment(); // 1
///   await counter.close();
/// }
/// ```
abstract class CachedStreamable<T> {
  /// {@macro cached_streamable}
  CachedStreamable(T initial) : _cache = initial;

  late final StreamController<T> _controller = StreamController<T>.broadcast();

  T _cache;

  /// Update the cache.
  @protected
  set cache(T value) {
    if (_cache == value) return;
    _controller.add(_cache = value);
  }

  /// Current [cache] value.
  @protected
  T get cache => _cache;

  /// Closes this instance.
  FutureOr<void> close() => _controller.close();

  /// Whether this has been closed or not.
  bool get isClosed => _controller.isClosed;

  /// The [stream] of cached values.
  Stream<T> get stream async* {
    yield cache;
    yield* _controller.stream;
  }
}
