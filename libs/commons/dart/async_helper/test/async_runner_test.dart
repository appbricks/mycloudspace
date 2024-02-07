import 'dart:developer';
import 'dart:async';
import 'dart:isolate';
import 'package:test/test.dart';

import 'package:async_helper/async_helper.dart';

void main() {
  group('AsyncRunner', () {
    AsyncRunner? asyncRunner;

    setUp(() {
      asyncRunner = AsyncRunner();
    });

    tearDown(() {
      asyncRunner!.dispose();
    });

    test('should execute request and return response', () async {
      final intVal = await asyncRunner!.run<int, int>(
        request: 123,
        task: (request) async {
          return request! + 456;
        },
      );
      expect(intVal, 579);

      final dblValue = await asyncRunner!.run<double, double>(
        request: 0.123,
        task: (request) async {
          return request! + 0.456;
        },
      );
      expect(dblValue, 0.579);

      final mainIsolateId = Service.getIsolateId(Isolate.current);
      final isolateId = await asyncRunner!.run<String, String>(
        task: (request) async {
          return Service.getIsolateId(Isolate.current);
        },
      );
      print('mainIsolateId: $mainIsolateId');
      print('isolateId: $isolateId');
      expect(mainIsolateId, isNot(isolateId));
    });

    test('should execute request with updates via callback', () async {
      List<int> updates1 = [];
      List<int> updates2 = [];

      Future<void> updateHandler(int message, String? id) async {
        if (id == '1') {
          updates1.add(message);
        } else if (id == '2') {
          updates2.add(message);
        }

        throw Exception('test exception');
      }

      final intVal1 = await asyncRunner!.runWithCallback<int, int, int>(
        request: 123,
        task: (sendMessage, request) async {
          await Future.delayed(const Duration(seconds: 1));
          sendMessage(3);
          await Future.delayed(const Duration(seconds: 1));
          sendMessage(2);
          await Future.delayed(const Duration(seconds: 1));
          sendMessage(1);
          await Future.delayed(const Duration(seconds: 1));
          return request! + 456;
        },
        callback: updateHandler,
        callbackId: '1',
      );

      final intVal2 = await asyncRunner!.runWithCallback<int, int, int>(
        request: 789,
        task: (sendMessage, request) async {
          await Future.delayed(const Duration(seconds: 1));
          sendMessage(7);
          await Future.delayed(const Duration(seconds: 1));
          sendMessage(8);
          await Future.delayed(const Duration(seconds: 1));
          sendMessage(9);
          await Future.delayed(const Duration(seconds: 1));
          return request! + 987;
        },
        callback: updateHandler,
        callbackId: '2',
      );

      expect(updates1, [3, 2, 1]);
      expect(intVal1, 579);
      expect(updates2, [7, 8, 9]);
      expect(intVal2, 1776);
    });

    test('should execute request with updates via stream', () async {
      List<int> updates1 = [];
      StreamController<int> stream1 = StreamController<int>();
      StreamSubscription<int> sub1 = stream1.stream.listen((data) {
        updates1.add(data);
      });

      List<int> updates2 = [];
      StreamController<int> stream2 = StreamController<int>();
      StreamSubscription<int> sub2 = stream2.stream.listen((data) {
        updates2.add(data);
      });

      try {
        final intVal1 = await asyncRunner!.runWithStream<int, int, int>(
          request: 123,
          task: (sendMessage, request) async {
            await Future.delayed(const Duration(seconds: 1));
            sendMessage(3);
            await Future.delayed(const Duration(seconds: 1));
            sendMessage(2);
            await Future.delayed(const Duration(seconds: 1));
            sendMessage(1);
            await Future.delayed(const Duration(seconds: 1));
            return request! + 456;
          },
          stream: stream1,
        );

        final intVal2 = await asyncRunner!.runWithStream<int, int, int>(
          request: 789,
          task: (sendMessage, request) async {
            await Future.delayed(const Duration(seconds: 1));
            sendMessage(7);
            await Future.delayed(const Duration(seconds: 1));
            sendMessage(8);
            await Future.delayed(const Duration(seconds: 1));
            sendMessage(9);
            await Future.delayed(const Duration(seconds: 1));
            return request! + 987;
          },
          stream: stream2,
        );

        expect(updates1, [3, 2, 1]);
        expect(intVal1, 579);
        expect(updates2, [7, 8, 9]);
        expect(intVal2, 1776);
      } finally {
        sub1.cancel();
        stream1.close();
        sub2.cancel();
        stream2.close();
      }
    });
  });
}
