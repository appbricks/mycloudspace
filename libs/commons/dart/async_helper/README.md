
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
  async_helper_ab: ^0.0.1
```
