import 'dart:async';

import 'package:meta/meta.dart';

/// {@macro update_when}
typedef UpdateWhen<T> = bool Function(T, T);

/// {@template cached_streamable}
/// Make any data type streamable.
/// {@endtemplate}
///
/// [value] is the initial seeded value of the object.
///
/// {@macro update_when}
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
  CachedStreamable(
    T value, {
    this.updateWhen,
  }) : _value = value;

  late final StreamController<T> _controller = StreamController<T>.broadcast();

  T _value;

  /// {@template update_when}
  /// Set a [updateWhen] to control when an old value should be updated
  /// with a new value. If not provided, the [defaultUpdateWhen] will be used:
  /// {@endtemplate}
  final UpdateWhen<T>? updateWhen;

  /// Update the cached value.
  set value(T value) {
    final shouldUpdate =
        updateWhen?.call(_value, value) ?? defaultUpdateWhen(_value, value);
    if (!shouldUpdate) return;
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

/// Check whether the two values are equal: `==`.
@visibleForTesting
bool defaultUpdateWhen<T>(T oldValue, T newValue) => oldValue != newValue;
