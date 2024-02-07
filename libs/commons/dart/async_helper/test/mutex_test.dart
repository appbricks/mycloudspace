import 'package:test/test.dart';

import 'package:async_helper/mutex.dart';

void main() {
  group('Mutex', () {
    test('lock should block until unlock is called', () async {
      Mutex mutex = Mutex();
      await mutex.lock();

      int lockCount = 0;
      mutex.lock().then((_) {
        print('lock acquired ${++lockCount}');
      });
      mutex.lock().then((_) {
        print('lock acquired ${++lockCount}');
      });
      mutex.lock().then((_) {
        print('lock acquired ${++lockCount}');
      });

      await Future.delayed(const Duration(milliseconds: 500));
      await Future.delayed(const Duration(milliseconds: 500));
      expect(lockCount, 0);

      mutex.unlock();
      await Future.delayed(const Duration(milliseconds: 500));
      await Future.delayed(const Duration(milliseconds: 500));
      await Future.delayed(const Duration(milliseconds: 500));
      expect(lockCount, 1);

      mutex.unlock();
      await Future.delayed(const Duration(milliseconds: 500));
      await Future.delayed(const Duration(milliseconds: 500));
      expect(lockCount, 2);

      mutex.unlock();
      await Future.delayed(const Duration(milliseconds: 500));
      expect(lockCount, 3);
    });
  });
}
