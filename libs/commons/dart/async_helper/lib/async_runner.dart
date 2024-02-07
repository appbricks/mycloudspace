import 'dart:developer';
import 'dart:async';
import 'dart:isolate';

import 'package:async_helper/mutex.dart';

// The AsyncRunner is a helper class that can be
// used to run code in an isolate and return the
// result to the caller. This can be used to create
// asynchronous bindings to foreign code. In such
// use cases you must be careful not to call foreign
// code from the isolate that will call back into
// Dart code via an interface skeleton that was
// created on the main isolate. This class is not
// limited to such use cases though.
class AsyncRunner {
  // Executes the given task request in an isolate
  // and returns a future with the response.
  Future<Response_T> run<Request_T, Response_T>({
    required AsyncTask<Request_T, Response_T> task,
    Request_T? request,
  }) async {
    await _lock.lock();
    try {
      // Port to the isolate that executes the request.
      final asyncIsolatePort = await _asyncIsolatePort();
      // Create the request.
      final asyncRequest = _AsyncRequestWithoutCallback<Request_T, Response_T>(
        task,
        request,
      );
      // Completer used to return the future response.
      final completer = Completer<Response_T>();
      _asyncCalls[asyncRequest.id] = _AsyncCall<Response_T, dynamic>(
        completer,
        asyncRequest,
        null,
        null,
        null,
      );
      asyncIsolatePort.send(asyncRequest);
      return completer.future;
    } finally {
      _lock.unlock();
    }
  }

  // Executes the given task request in an isolate
  // and returns a future with the response when
  // complete. The task can send messages to the
  // the callback during the course of its execution.
  Future<Response_T> runWithCallback<Request_T, Response_T, Message_T>({
    required AsyncTaskWithSend<Request_T, Response_T, Message_T> task,
    required AsyncCallback<Message_T> callback,
    String? callbackId,
    Request_T? request,
  }) async {
    await _lock.lock();
    try {
      // Port to the isolate that executes the request.
      final asyncIsolatePort = await _asyncIsolatePort();
      // Create the request.
      final asyncRequest =
          _AsyncRequestWithCallback<Request_T, Response_T, Message_T>(
        task,
        request,
      );
      // Completer used to return the future response.
      final completer = Completer<Response_T>();
      _asyncCalls[asyncRequest.id] = _AsyncCall<Response_T, Message_T>(
        completer,
        asyncRequest,
        null,
        callback,
        callbackId,
      );
      asyncIsolatePort.send(asyncRequest);
      return completer.future;
    } finally {
      _lock.unlock();
    }
  }

  // Executes the given task request in an isolate
  // and returns a future with the response when
  // complete. The task can send messages to the
  // the stream during the course of its execution.
  Future<Response_T> runWithStream<Request_T, Response_T, Message_T>({
    required AsyncTaskWithSend<Request_T, Response_T, Message_T> task,
    required StreamController<Message_T> stream,
    Request_T? request,
  }) async {
    await _lock.lock();
    try {
      // Port to the isolate that executes the request.
      final asyncIsolatePort = await _asyncIsolatePort();
      // Create the request.
      final asyncRequest =
          _AsyncRequestWithCallback<Request_T, Response_T, Message_T>(
        task,
        request,
      );
      // Completer used to return the future response.
      final completer = Completer<Response_T>();
      _asyncCalls[asyncRequest.id] = _AsyncCall<Response_T, Message_T>(
        completer,
        asyncRequest,
        stream,
        null,
        null,
      );
      asyncIsolatePort.send(asyncRequest);
      return completer.future;
    } finally {
      _lock.unlock();
    }
  }

  // Returns the number of requests
  // that are currently in flight
  Future<int> numInFlightRequests() async {
    await _lock.lock();
    try {
      return _asyncCalls.length;
    } finally {
      _lock.unlock();
    }
  }

  // Shuts down the isolate.
  dispose() {
    _receivePort?.close();
    _isolate?.kill();
  }

  final Map<int, _AsyncCall> _asyncCalls = <int, _AsyncCall>{};

  final Mutex _lock = Mutex();

  SendPort? _sendPort;
  Isolate? _isolate;

  ReceivePort? _receivePort;

  _asyncIsolatePort() async {
    // The SendPort to the helper isolate which is
    // spawned only at the first invocation of the
    // runner's run function.
    _sendPort ??= await _getAsyncHelperIsolatePort();
    return _sendPort;
  }

  // Spawns the helper isolate for this async
  // instance and sets up the communication port.
  Future<SendPort> _getAsyncHelperIsolatePort() async {
    // The helper isolate is going to send us back a
    // SendPort, which we want to wait for.
    final Completer<SendPort> completer = Completer<SendPort>();

    // Receive port on the main isolate to receive
    // messages from the helper.
    //
    // We receive two types of messages:
    // 1. A port to send messages on.
    // 2. Responses to requests we sent.
    _receivePort = ReceivePort()
      ..listen((dynamic data) {
        if (data is SendPort) {
          // The helper isolate sent us the port
          // on which we can send it requests.
          completer.complete(data);
          return;
        }
        if (data is _AsyncUpdate) {
          // The helper isolate sent us an update
          // to a request we sent.
          final _AsyncCall? asyncCall = _asyncCalls[data.id];
          if (asyncCall != null) {
            asyncCall.invokeCallback(data.message).onError(
              (error, stackTrace) {
                log(
                  'ERROR! Unhandled error in callback!',
                  error: error,
                  stackTrace: stackTrace,
                );
              },
            );
          } else {
            log('ERROR! Unknown callback id: ${data.id}');
          }
          return;
        }
        if (data is _AsyncResponse) {
          // The helper isolate sent us a
          // response to a request we sent.
          final _AsyncCall asyncCall = _asyncCalls[data.id]!;

          _asyncCalls.remove(data.id);
          if (data.error == null) {
            asyncCall.completer.complete(data.response);
          } else {
            asyncCall.completer.completeError(
              data.error!,
              data.stackTrace,
            );
          }
          return;
        }
        throw UnsupportedError('Unsupported message type: ${data.runtimeType}');
      });

    // Start the helper isolate.
    _isolate = await Isolate.spawn(
      (SendPort sendPort) async {
        final ReceivePort helperReceivePort = ReceivePort()
          ..listen((dynamic data) {
            // On the helper isolate listen to
            // requests and respond to them.
            if (data is _AsyncRequestWithoutCallback) {
              data.execute().then(
                (response) {
                  sendPort.send(_AsyncResponse(
                    data.id,
                    response,
                    null,
                    null,
                  ));
                },
              ).onError(
                (error, stackTrace) {
                  sendPort.send(_AsyncResponse(
                    data.id,
                    null,
                    error,
                    stackTrace,
                  ));
                },
              );
              return;
            }
            if (data is _AsyncRequestWithCallback) {
              data.execute(sendPort).then(
                (response) {
                  sendPort.send(_AsyncResponse(
                    data.id,
                    response,
                    null,
                    null,
                  ));
                },
              ).onError(
                (error, stackTrace) {
                  sendPort.send(_AsyncResponse(
                    data.id,
                    null,
                    error,
                    stackTrace,
                  ));
                },
              );
              return;
            }
            throw UnsupportedError(
                'Unsupported message type: ${data.runtimeType}');
          });

        // Send the port to the main isolate
        // on which we can receive requests.
        sendPort.send(helperReceivePort.sendPort);
      },
      _receivePort!.sendPort,
    );

    // Wait until the helper isolate has sent us back the SendPort on which we
    // can start sending requests.
    return completer.future;
  }
}

// A function that will be executed in the isolate.
typedef AsyncTask<Request_T, Response_T> = Future<Response_T?> Function(
  Request_T? request,
);
// A function that will be execute in the isolate and can
// send message to the main isolate before completion.
typedef AsyncTaskWithSend<Request_T, Response_T, Message_T>
    = Future<Response_T?> Function(
  SendMessage<Message_T> sendMessage,
  Request_T? request,
);
// A callback that will execute in the main isolate to handle
// messages from the task executing in an isolate
typedef AsyncCallback<Message_T> = Future<void> Function(
  Message_T message,
  String? callbackId,
);
// Sends a message to the main isolate
typedef SendMessage<Message_T> = Future<void> Function(
  Message_T message,
);

// An AsyncRequest is a request that is executed in an isolate.
class _AsyncRequest {
  static int nextId = 0;
  late final int id;

  _AsyncRequest() {
    id = nextId++;
  }
}

class _AsyncRequestWithoutCallback<Request_T, Response_T>
    extends _AsyncRequest {
  final AsyncTask<Request_T, Response_T> task;
  final Request_T? request;

  _AsyncRequestWithoutCallback(this.task, this.request);

  Future<Response_T?> execute() async {
    return task(request);
  }
}

class _AsyncRequestWithCallback<Request_T, Response_T, Message_T>
    extends _AsyncRequest {
  final AsyncTaskWithSend<Request_T, Response_T, Message_T> task;
  final Request_T? request;

  _AsyncRequestWithCallback(this.task, this.request);

  Future<Response_T?> execute(SendPort sendPort) async {
    return task(
      (message) async {
        sendPort.send(_AsyncUpdate(id, message));
      },
      request,
    );
  }
}

class _AsyncUpdate<Message_T> {
  final int id;
  final Message_T message;

  _AsyncUpdate(this.id, this.message);
}

class _AsyncResponse<Response_T> {
  final int id;
  final Response_T? response;

  final Object? error;
  final StackTrace? stackTrace;

  _AsyncResponse(this.id, this.response, this.error, this.stackTrace);
}

class _AsyncCall<Response_T, Message_T> {
  final Completer<Response_T> completer;

  final StreamController<Message_T>? stream;

  final AsyncCallback<Message_T>? callback;
  final String? callbackId;

  final _AsyncRequest? request;

  _AsyncCall(
    this.completer,
    this.request,
    this.stream,
    this.callback,
    this.callbackId,
  );

  Future<void> invokeCallback(Message_T message) {
    if (callback != null) {
      return callback!(message, callbackId);
    } else if (stream != null) {
      stream!.add(message);
    }
    return Future.value();
  }
}
