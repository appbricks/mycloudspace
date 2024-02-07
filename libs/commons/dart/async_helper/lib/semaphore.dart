import 'dart:async';
import 'dart:collection';

class Semaphore {
  int _permits;
  final Queue<Completer<void>> _waitQueue = Queue<Completer<void>>();

  Semaphore(this._permits) : assert(_permits > 0);

  Future<void> acquire() {
    if (_permits > 0) {
      _permits--;
      return Future.value();
    } else {
      Completer<void> completer = Completer<void>();
      _waitQueue.add(completer);
      return completer.future;
    }
  }

  void release() {
    if (_waitQueue.isNotEmpty) {
      Completer<void> completer = _waitQueue.removeFirst();
      completer.complete();
    } else {
      _permits++;
    }
  }
}
