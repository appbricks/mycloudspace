import 'dart:async';
import 'package:test/test.dart';

import 'package:async_helper_ab/async_helper.dart';

void main() {
  group('AsyncScheduler', () {
    AsyncScheduler<int, int>? scheduler;

    Future<int?> task(int? request) async {
      await Future.delayed(const Duration(seconds: 2));
      final reversed = request!.toString().split('').reversed.join();
      return request + int.parse(reversed);
    }

    setUp(() {
      scheduler = AsyncScheduler<int, int>(
        concurrency: 4,
        task: task,
      );
    });

    tearDown(() {
      scheduler!.dispose();
    });

    test('should execute request in isolate and return response', () async {
      Map<int, int?> intVals = {};

      scheduler!.run(request: 123).then((intVal) {
        intVals[123] = intVal;
      });
      scheduler!.run(request: 456).then((intVal) {
        intVals[456] = intVal;
      });
      scheduler!.run(request: 789).then((intVal) {
        intVals[789] = intVal;
      });
      scheduler!.run(request: 987).then((intVal) {
        intVals[987] = intVal;
      });
      scheduler!.run(request: 654).then((intVal) {
        intVals[654] = intVal;
      });

      await Future.delayed(const Duration(seconds: 1));
      final numInFlightRequests = await scheduler!.debugString();
      print('numInFlightRequests: $numInFlightRequests');
      expect(numInFlightRequests, 'Scheduler: [2, 1, 1, 1]');

      await Future.delayed(const Duration(seconds: 2));
      print('intVals: $intVals');
      expect(intVals[123], 444);
      expect(intVals[456], 1110);
      expect(intVals[789], 1776);
      expect(intVals[987], 1776);
      expect(intVals[654], 1110);
    });
  });

  group('AsyncSchedulerWithCallback', () {
    AsyncSchedulerWithCallback<int, int, int>? scheduler;

    Map<String, List<int?>> messages = {};

    Future<int?> task(SendMessage<int> sendMessage, int? request) async {
      await Future.delayed(const Duration(seconds: 1));
      sendMessage(request! * 2);
      await Future.delayed(const Duration(seconds: 1));
      sendMessage(request * 3);

      final reversed = request.toString().split('').reversed.join();
      return request + int.parse(reversed);
    }

    Future<void> handler(int message, String? id) async {
      List<int?> updates = messages[id!] ?? [];
      updates.add(message);
      messages[id] = updates;
    }

    setUp(() {
      scheduler = AsyncSchedulerWithCallback<int, int, int>(
        concurrency: 2,
        task: task,
        callback: handler,
      );
    });

    tearDown(() {
      scheduler!.dispose();
    });

    test('should execute request in isolate and return response', () async {
      Map<int, int?> intVals = {};

      scheduler!.run(request: 123, callbackId: '123').then((intVal) {
        intVals[123] = intVal;
      });
      scheduler!.run(request: 456, callbackId: '456').then((intVal) {
        intVals[456] = intVal;
      });
      scheduler!.run(request: 789, callbackId: '789').then((intVal) {
        intVals[789] = intVal;
      });
      scheduler!.run(request: 987, callbackId: '987').then((intVal) {
        intVals[987] = intVal;
      });
      scheduler!.run(request: 654, callbackId: '654').then((intVal) {
        intVals[654] = intVal;
      });

      await Future.delayed(const Duration(seconds: 1));
      final numInFlightRequests = await scheduler!.debugString();
      print('numInFlightRequests: $numInFlightRequests');
      expect(numInFlightRequests, 'Scheduler: [3, 2]');

      await Future.delayed(const Duration(seconds: 2));
      print('intVals: $intVals');
      expect(intVals[123], 444);
      expect(intVals[456], 1110);
      expect(intVals[789], 1776);
      expect(intVals[987], 1776);
      expect(intVals[654], 1110);

      print('messages: $messages');
      expect(messages['123'], [246, 369]);
      expect(messages['456'], [912, 1368]);
      expect(messages['789'], [1578, 2367]);
      expect(messages['987'], [1974, 2961]);
      expect(messages['654'], [1308, 1962]);
    });
  });

  group('AsyncSchedulerWithStreams', () {
    AsyncSchedulerWithStreams<int, int, int>? scheduler;

    Map<String, List<int?>> messages = {};

    Future<int?> task(SendMessage<int> sendMessage, int? request) async {
      await Future.delayed(const Duration(seconds: 1));
      sendMessage(request! * 2);
      await Future.delayed(const Duration(seconds: 1));
      sendMessage(request * 3);

      final reversed = request.toString().split('').reversed.join();
      return request + int.parse(reversed);
    }

    Future<void> handler(int message, String? id) async {
      List<int?> updates = messages[id!] ?? [];
      updates.add(message);
      messages[id] = updates;
    }

    (StreamController<int>, StreamSubscription<int>) createStream(String id) {
      StreamController<int> stream = StreamController<int>();
      StreamSubscription<int> sub2 = stream.stream.listen((data) {
        List<int?> updates = messages[id] ?? [];
        updates.add(data);
        messages[id] = updates;
      });
      return (stream, sub2);
    }

    setUp(() {
      scheduler = AsyncSchedulerWithStreams<int, int, int>(
        concurrency: 2,
        task: task,
      );
    });

    tearDown(() {
      scheduler!.dispose();
    });

    test('should execute request in isolate and return response', () async {
      Map<int, int?> intVals = {};

      final (stream123, sub123) = createStream('123');
      final (stream456, sub456) = createStream('456');
      final (stream789, sub789) = createStream('789');
      final (stream987, sub987) = createStream('987');
      final (stream654, sub654) = createStream('654');

      try {
        scheduler!.run(request: 123, stream: stream123).then((intVal) {
          intVals[123] = intVal;
        });
        scheduler!.run(request: 456, stream: stream456).then((intVal) {
          intVals[456] = intVal;
        });
        scheduler!.run(request: 789, stream: stream789).then((intVal) {
          intVals[789] = intVal;
        });
        scheduler!.run(request: 987, stream: stream987).then((intVal) {
          intVals[987] = intVal;
        });
        scheduler!.run(request: 654, stream: stream654).then((intVal) {
          intVals[654] = intVal;
        });

        await Future.delayed(const Duration(seconds: 1));
        final numInFlightRequests = await scheduler!.debugString();
        print('numInFlightRequests: $numInFlightRequests');
        expect(numInFlightRequests, 'Scheduler: [3, 2]');

        await Future.delayed(const Duration(seconds: 2));
        print('intVals: $intVals');
        expect(intVals[123], 444);
        expect(intVals[456], 1110);
        expect(intVals[789], 1776);
        expect(intVals[987], 1776);
        expect(intVals[654], 1110);

        print('messages: $messages');
        expect(messages['123'], [246, 369]);
        expect(messages['456'], [912, 1368]);
        expect(messages['789'], [1578, 2367]);
        expect(messages['987'], [1974, 2961]);
        expect(messages['654'], [1308, 1962]);
      } finally {
        sub123.cancel();
        sub456.cancel();
        sub789.cancel();
        sub987.cancel();
        sub654.cancel();

        stream123.close();
        stream456.close();
        stream789.close();
        stream987.close();
        stream654.close();
      }
    });
  });
}
