import 'dart:async';

// A mutex is a mutual exclusion object that synchronizes
// access to a critical section of code,
//
// This is guaranteed to block the thread until no other
// thread holds a lock on the mutex and thus enforces
// exclusive access to the resource. Once the operation is
// complete, the thread releases the lock, allowing other
// threads to acquire a lock and access the resource.
class Mutex {
  Completer<void>? _lock;
  int _owners = 0;

  // locks the mutex
  Future<void> lock() async {
    while (_lock != null) {
      await _lock!.future;
    }

    _lock ??= Completer<void>();
    if (_owners > 0) {
      // if additional threads arrive here
      // send them back to the lock() method
      lock();
    } else {
      _owners++;
    }
  }

  // unlocks the mutex
  void unlock() {
    assert(_lock != null);

    final lock = _lock!;
    _lock = null;

    _owners--;
    lock.complete();
  }
}
