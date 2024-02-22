import 'package:flutter/material.dart';

import 'package:nav_layouts_component/nav_layouts.dart';

import 'package:service_integration_tests/config/app_config.dart';
import 'package:service_integration_tests/state/app_state.dart';
import 'package:service_integration_tests/screens/home_page.dart';
import 'package:service_integration_tests/screens/identity_service_tests/sign_up_test.dart';
import 'package:service_integration_tests/screens/identity_service_tests/sign_in_test.dart';

class IdentityServicePage extends RootNavLayout {
  /// The initial path within the navigation shell
  static const String name = SignInTestPage.name;

  @override
  List<NavTarget> get navTargets => [
        NavTarget(
          icon: const Icon(Icons.person_add),
          selectedIcon: const Icon(Icons.person_add_sharp),
          label: 'Sign Up',
          body: SignInTestPage(appState),
        ),
        NavTarget(
          icon: const Icon(Icons.login),
          selectedIcon: const Icon(Icons.login_sharp),
          label: 'Sign In',
          body: SignUpTestPage(appState),
        ),
      ];

  @override
  TitleBar? get titleBar {
    return TitleBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new),
        onPressed: () {
          appState.navigateTo(HomePage.name);
        },
      ),
    );
  }

  final AppState appState;

  const IdentityServicePage(
    this.appState,
  ) : super(AppConfig.title, appState);
}
