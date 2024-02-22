import 'package:flutter/material.dart';

import 'package:nav_layouts_component/nav_layouts.dart';

import 'package:service_integration_tests/config/app_config.dart';
import 'package:service_integration_tests/state/app_state.dart';

import 'package:service_integration_tests/screens/test_list_view.dart';

class HomePage extends NavigableWidget {
  @override
  String get routeName => name;
  static const String name = 'HomePage';

  @override
  String get routePath => path;
  static const String path = '/';

  final AppState appState;

  const HomePage(this.appState, {super.key});

  @override
  Widget build(BuildContext context) {
    return RootLayout(
      body: const TestListView(),
      splash: Image.asset(
        'assets/matrix.jpeg',
        height: double.infinity,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
      isSplash: true,
      title: AppConfig.title,
      state: appState,
    );
  }
}
