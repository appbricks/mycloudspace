
![Pub](https://img.shields.io/pub/v/bottom_navy_bar)

A set of utility classes that simplify running asynchronous tasks within isolates and managing the communication between them and the main isolate.

## Features

* Manager classes to manage the lifecycle of an isolate or pool of isolates for running tasks
* Easy implementation of tasks with support for callbacks and streaming from the isolate running the task to the main isolate
* Mutex and semaphore constructs to assist in synchronization when sharing resource between concurrent jobs

## Getting started

Add the dependency in `pubspec.yaml`:

```yaml
dependencies:
  ...
  async_helper: ^0.0.1
```

## Usage

> Detail usage examples may be found within the unit test suite. 

Create an isolate to handle single task

```dart
final asyncRunner = AsyncRunner();

final intVal = await asyncRunner!.run<int, int>(
    request: 123,
    task: (request) async {
        return request! + 456;
    },
);

// intVal == 579
```

Create an isolate to handle single task with callback

```dart
final asyncRunner = AsyncRunner();

final intVal = await asyncRunner!.runWithCallback<int, int, int>(
    request: 123,
    task: (sendMessage, request) async {
        sendMessage(request! + 321);
        return request! + 123;
    },
    callback: (message, id) async {
        // message == 444
        // id == 999
    },
    999,
);

// intVal == 246
```

Create an isolate to handle single task that can send data via stream until task completes

```dart
final asyncRunner = AsyncRunner();

StreamController<int> stream1 = StreamController<int>();
    StreamSubscription<int> sub1 = stream1.stream.listen((data) {
        // data == 124 <after 1s> 125 <after 1s> 126
    });

final intVal1 = await asyncRunner!.runWithStream<int, int, int>(
    request: 123,
    task: (sendMessage, request) async {
        sendMessage(request! + 1);
        await Future.delayed(const Duration(seconds: 1));
        sendMessage(request! + 2);
        await Future.delayed(const Duration(seconds: 1));
        sendMessage(request! + 3);
        await Future.delayed(const Duration(seconds: 1));
        return request! + 456;
    },
    stream: stream1,
);

// intVal == 246
```