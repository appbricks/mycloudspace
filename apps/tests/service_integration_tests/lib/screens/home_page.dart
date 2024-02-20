import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:nav_layouts_component/nav_layouts.dart';

import 'package:service_integration_tests/config/app_config.dart';
import 'package:service_integration_tests/state/app_state.dart';

import 'package:service_integration_tests/screens/test_list_view.dart';

class HomePage extends StatelessWidget {
  /// The path and route to navigate to this page
  static const String path = '/';
  static GoRoute route({Key? key, required AppState appState}) {
    return GoRoute(
      path: HomePage.path,
      builder: (context, state) {
        return HomePage(key: key, appState: appState);
      },
    );
  }

  final AppState appState;

  const HomePage({super.key, required this.appState});

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
