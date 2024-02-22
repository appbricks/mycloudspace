import 'package:flutter/material.dart';

import 'package:nav_layouts_component/nav_layouts.dart';

import 'package:service_integration_tests/state/app_state.dart';

class SignInTestPage extends NavigableWidget {
  @override
  String get routeName => name;
  static const String name = 'SignInTestPage';

  @override
  String get routePath => path;
  static const String path = '/sign-in-test';

  final AppState _appState;

  const SignInTestPage(this._appState, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Sign In Test Page',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
    );
  }
}
