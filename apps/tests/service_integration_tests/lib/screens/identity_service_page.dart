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
          body: SignInTestPage(appState),
        ),
        NavTarget(
          body: SignUpTestPage(appState),
        ),
      ];

  @override
  NavProperties get navProperties => const NavProperties(
        showExtended: ShowExtended.dynamic,
        showLabels: ShowLabels.whenExtended,
      );

  @override
  List<NavDest> buildNavDests(BuildContext context) {
    return [
      NavDest(
        iconData: Icons.person_add,
        selectedIconData: Icons.person_add_sharp,
        label: 'Sign Up',
      ),
      NavDest(
        iconData: Icons.login,
        selectedIconData: Icons.login_sharp,
        label: 'Sign In',
      ),
    ];
  }

  @override
  NavTitleBar? buildNavTitleBar(BuildContext context) {
    return NavTitleBar(
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new,
          color: Theme.of(context).textTheme.titleLarge!.color,
        ),
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
