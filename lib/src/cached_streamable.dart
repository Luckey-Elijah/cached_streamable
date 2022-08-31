import 'dart:async';

/// {@template cached_streamable}
/// Make any data type streamable.
/// {@endtemplate}
///
/// **Example**
/// ```dart
/// Future<void> main() async {
///   final counter = CachedStreamable<int>(0)..stream.listen(print);
///   counter.value++;
///   await counter.close();
/// }
/// ```
class CachedStreamable<T> {
  /// {@macro cached_streamable}
  CachedStreamable(T value) : _value = value;

  late final StreamController<T> _controller = StreamController<T>.broadcast();

  T _value;

  /// Update the cached value.
  set value(T value) {
    if (_value == value) return;
    _controller.add(_value = value);
  }

  /// Current cached value.
  T get value => _value;

  /// Closes this instance.
  FutureOr<void> close() => _controller.close();

  /// Whether this has been closed or not.
  bool get isClosed => _controller.isClosed;

  /// The [stream] of cached values.
  Stream<T> get stream async* {
    yield value;
    yield* _controller.stream;
  }
}
