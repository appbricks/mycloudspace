import 'package:flutter/material.dart';

import 'package:nav_layouts_component/nav_layouts.dart';

import 'package:service_integration_tests/state/app_state.dart';

class SignUpTestPage extends NavigableWidget {
  @override
  String get routeName => name;
  static const String name = 'SignUpTestPage';

  @override
  String get routePath => path;
  static const String path = '/sign-up-test';

  final AppState _appState;

  const SignUpTestPage(this._appState, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Sign Up Test Page',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
    );
  }
}
