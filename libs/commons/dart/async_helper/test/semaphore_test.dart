import 'package:test/test.dart';

import 'package:async_helper/semaphore.dart';

void main() {
  group('Semaphore', () {
    test('sempahore should block after 2 permits', () async {
      Semaphore sem = Semaphore(2);

      int permitCount = 0;
      sem.acquire().then((_) {
        print('sempafore acquired ${++permitCount}');
      });
      sem.acquire().then((_) {
        print('sempafore acquired ${++permitCount}');
      });
      sem.acquire().then((_) {
        print('sempafore acquired ${++permitCount}');
      });
      sem.acquire().then((_) {
        print('sempafore acquired ${++permitCount}');
      });
      sem.acquire().then((_) {
        print('sempafore acquired ${++permitCount}');
      });
      sem.acquire().then((_) {
        print('sempafore acquired ${++permitCount}');
      });

      await Future.delayed(const Duration(milliseconds: 500));
      await Future.delayed(const Duration(milliseconds: 500));
      await Future.delayed(const Duration(milliseconds: 500));
      expect(permitCount, 2);

      sem.release();
      await Future.delayed(const Duration(milliseconds: 500));
      await Future.delayed(const Duration(milliseconds: 500));
      expect(permitCount, 3);

      sem.release();
      await Future.delayed(const Duration(milliseconds: 500));
      expect(permitCount, 4);

      sem.release();
      await Future.delayed(const Duration(milliseconds: 500));
      expect(permitCount, 5);
    });
  });
}
