import 'package:cached_streamable/cached_streamable.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

// ignore: one_member_abstracts
abstract class TestFunction<T> {
  bool updateWhen(T oldValue, T newValue);
}

class MockTestFunction<T> extends Mock implements TestFunction<T> {}

void main() {
  group('CachedStreamable<T>', () {
    test('can have multiple listeners', () {
      final _cachedStreamable = CachedStreamable<int>(0);

      _cachedStreamable.stream.listen((_) {});
      void f() => _cachedStreamable.stream.listen((_) {});
      expect(f, returnsNormally);
    });

    test('close() closes the controller', () {
      final _cachedStreamable = CachedStreamable<int>(0);

      void f() => _cachedStreamable.close();

      expect(f, returnsNormally);
      expect(_cachedStreamable.isClosed, isTrue);
    });

    test('value setter updates with new cache', () {
      final _cachedStreamable = CachedStreamable<int>(0);

      void f() => _cachedStreamable.value = 1;
      expect(_cachedStreamable.stream, emits(1));
      expect(f, returnsNormally);
    });

    test('value setter emits nothing with identical value', () {
      const seed = 0;
      final _cachedStreamable = CachedStreamable<int>(seed);

      void f() => _cachedStreamable.value = seed;
      expect(_cachedStreamable.stream, emitsInOrder([0]));
      expect(f, returnsNormally);
    });

    test('uses [updateWhen] when provided', () {
      final testFunc = MockTestFunction<int>();
      when(() => testFunc.updateWhen(any(), any())).thenReturn(true);

      final _cachedStreamable =
          CachedStreamable<int>(0, updateWhen: testFunc.updateWhen);

      _cachedStreamable.value++;

      verify(
        () => testFunc.updateWhen(any(), any()),
      ).called(1);
    });
  });
}
