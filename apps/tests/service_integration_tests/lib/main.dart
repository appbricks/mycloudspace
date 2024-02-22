import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:window_manager/window_manager.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';

// Amplify Flutter Packages
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

import 'package:utilities/logging/init_logging.dart';
import 'package:platform_utilities_component/platform_utilities.dart';
import 'package:nav_layouts_component/nav_layouts.dart';
import 'package:identity_service/identity_service.dart' as identity;

import 'package:service_integration_tests/config/app_config.dart';
import 'package:service_integration_tests/state/app_state.dart';
import 'package:service_integration_tests/screens/home_page.dart';
import 'package:service_integration_tests/screens/identity_service_page.dart';

import 'amplify_config.dart';

void main() async {
  initLogging(
    Level.ALL,
    logToConsole: true,
  );

  // On Desktop platforms the minimum size
  // of the window is fixed at 240x400
  if (!AppPlatform.isMobile) {
    WidgetsFlutterBinding.ensureInitialized();
    await windowManager.ensureInitialized();

    WindowManager.instance.setMinimumSize(AppConfig.minWindowSize);
    WindowManager.instance.setTitle(AppConfig.title);
  }

  AppPlatform.init().then(
    (_) => runApp(
      StatefulWrapper(
        onInit: () {
          _configureAmplify();
          GetIt.instance.registerLazySingleton<identity.Provider>(
            () {
              final service = identity.AWSProvider();
              return service;
            },
          );
        },
        onDespose: () {
          GetIt.instance.unregister<identity.Provider>();
        },
        child: MainApp(),
      ),
    ),
  );
}

class MainApp extends StatelessWidget {
  final AppState appState = AppState();
  late final GoRouter _router;

  MainApp({super.key}) {
    _router = GoRouter(
      navigatorKey: AppState.rootNavigatorKey,
      initialLocation: '/',
      routes: [
        HomePage(appState).route(),
        IdentityServicePage(appState).route(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    AppPlatform.initOnBuild(context);

    if (Platform.isMacOS) {
      // On macOS a system menu is a required part of every application
      final List<PlatformMenuItem> menus = <PlatformMenuItem>[
        PlatformMenu(
          label: '', // In macOS the application name is shown in the menu bar
          menus: <PlatformMenuItem>[
            PlatformMenuItemGroup(
              members: <PlatformMenuItem>[
                PlatformMenuItem(
                  label: 'About',
                  onSelected: () {
                    showAboutDialog(
                      context: context,
                      applicationName: AppConfig.title,
                      applicationVersion: AppConfig.version,
                    );
                  },
                ),
              ],
            ),
            if (PlatformProvidedMenuItem.hasMenu(
                PlatformProvidedMenuItemType.quit))
              const PlatformProvidedMenuItem(
                  type: PlatformProvidedMenuItemType.quit),
          ],
        ),
      ];
      WidgetsBinding.instance.platformMenuDelegate.setMenus(menus);
    }

    return ChangeNotifierProvider(
      create: (context) => appState,
      child: MaterialApp.router(
        title: AppConfig.title,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.indigo,
          ),
          useMaterial3: false,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            brightness: Brightness.dark,
            seedColor: Colors.indigo,
          ),
          useMaterial3: false,
        ),
        routerConfig: _router,
      ),
    );
  }
}

Future<void> _configureAmplify() async {
  // Add any Amplify plugins you want to use
  final authPlugin = AmplifyAuthCognito();
  await Amplify.addPlugin(authPlugin);

  // You can use addPlugins if you are going to be adding multiple plugins
  // await Amplify.addPlugins([authPlugin, analyticsPlugin]);

  // Once Plugins are added, configure Amplify
  // Note: Amplify can only be configured once.
  try {
    await Amplify.configure(amplifyConfig);
  } on AmplifyAlreadyConfiguredException {
    safePrint(
        "Tried to reconfigure Amplify; this can occur when your app restarts on Android.");
  }
}
