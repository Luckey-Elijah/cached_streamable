import 'package:cached_streamable/cached_streamable.dart';
import 'package:test/test.dart';

class FakeCachedStreamable extends CachedStreamable<int> {
  FakeCachedStreamable(super.initial);
}

void main() {
  group('CachedStreamable<T>', () {
    test('can have multiple listeners', () {
      final fakeCachedStreamable = FakeCachedStreamable(0);

      fakeCachedStreamable.stream.listen((_) {});
      void f() => fakeCachedStreamable.stream.listen((_) {});
      expect(f, returnsNormally);
    });

    test('close() closes the controller', () {
      final fakeCachedStreamable = FakeCachedStreamable(0);

      void f() => fakeCachedStreamable.close();

      expect(f, returnsNormally);
      expect(fakeCachedStreamable.isClosed, isTrue);
    });

    test('cache setter updates with new cache', () {
      final fakeCachedStreamable = FakeCachedStreamable(0);

      // ignore: invalid_use_of_protected_member
      void f() => fakeCachedStreamable.cache = 1;
      expect(fakeCachedStreamable.stream, emits(1));
      expect(f, returnsNormally);
    });

    test('cache setter emits nothing with identical value', () {
      const seed = 0;
      final fakeCachedStreamable = FakeCachedStreamable(seed);

      // ignore: invalid_use_of_protected_member
      void f() => fakeCachedStreamable.cache = seed;
      expect(fakeCachedStreamable.stream, emitsInOrder([0]));
      expect(f, returnsNormally);
    });
  });
}
