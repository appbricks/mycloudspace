import 'dart:async';

import 'package:async_helper_ab/mutex.dart';
import 'package:async_helper_ab/async_runner.dart';

class AsyncScheduler<Request_T, Response_T> extends Scheduler {
  late final AsyncTask<Request_T, Response_T> task;

  AsyncScheduler({
    int super.concurrency = 1,
    required this.task,
  });

  Future<Response_T?> run({
    Request_T? request,
  }) async {
    await _lock.lock();
    try {
      final asyncRunner = await super.nextAvailableRunner;

      return asyncRunner.run<Request_T, Response_T>(
        task: task,
        request: request,
      );
    } finally {
      _lock.unlock();
    }
  }
}

class AsyncSchedulerWithCallback<Request_T, Response_T, Message_T>
    extends Scheduler {
  late final AsyncTaskWithSend<Request_T, Response_T, Message_T> task;
  late final AsyncCallback<Message_T> callback;

  AsyncSchedulerWithCallback({
    int super.concurrency = 1,
    required this.task,
    required this.callback,
  });

  Future<Response_T?> run({
    String? callbackId,
    Request_T? request,
  }) async {
    await _lock.lock();
    try {
      final asyncRunner = await super.nextAvailableRunner;

      return asyncRunner.runWithCallback<Request_T, Response_T, Message_T>(
        task: task,
        callback: callback,
        callbackId: callbackId,
        request: request,
      );
    } finally {
      _lock.unlock();
    }
  }
}

class AsyncSchedulerWithStreams<Request_T, Response_T, Message_T>
    extends Scheduler {
  late final AsyncTaskWithSend<Request_T, Response_T, Message_T> task;

  AsyncSchedulerWithStreams({
    int super.concurrency = 1,
    required this.task,
  });

  Future<Response_T?> run({
    required StreamController<Message_T> stream,
    Request_T? request,
  }) async {
    await _lock.lock();
    try {
      final asyncRunner = await super.nextAvailableRunner;

      return asyncRunner.runWithStream<Request_T, Response_T, Message_T>(
        task: task,
        stream: stream,
        request: request,
      );
    } finally {
      _lock.unlock();
    }
  }
}

class Scheduler {
  late final List<AsyncRunner> asyncRunners;

  final Mutex _lock = Mutex();

  Scheduler({
    concurrency,
  }) {
    if (concurrency < 1) {
      throw Exception('concurrency must be greater than 0');
    }
    asyncRunners = List.generate(
      concurrency,
      (_) => AsyncRunner(),
    );
  }

  Future<void> dispose() async {
    for (final asyncRunner in asyncRunners) {
      await asyncRunner.dispose();
    }
  }

  Future<AsyncRunner> get nextAvailableRunner async {
    AsyncRunner asyncRunner = asyncRunners.first;
    int j = await asyncRunner.numInFlightRequests();
    for (int i = 1; j != 0 && i < asyncRunners.length; i++) {
      final runner = asyncRunners[i];
      final k = await runner.numInFlightRequests();
      if (k < j) {
        asyncRunner = runner;
        j = k;
      }
    }
    return asyncRunner;
  }

  Future<String> debugString() async {
    List<int> reqsInFlight = [];
    for (final asyncRunner in asyncRunners) {
      reqsInFlight.add(await asyncRunner.numInFlightRequests());
    }
    return 'Scheduler: [${reqsInFlight.join(', ')}]';
  }
}
