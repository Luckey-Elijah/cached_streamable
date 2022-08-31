import 'package:cached_streamable/cached_streamable.dart';
import 'package:test/test.dart';

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
  });
}
