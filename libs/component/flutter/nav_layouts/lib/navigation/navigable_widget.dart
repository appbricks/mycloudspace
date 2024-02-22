import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

abstract class Navigable {
  /// The name of this page for named navigation
  String get routeName;

  /// The path and route to navigate to this page
  String get routePath;

  RouteBase route();
}

abstract class NavigableWidget extends StatelessWidget implements Navigable {
  const NavigableWidget({super.key});

  @override
  RouteBase route() {
    return GoRoute(
      name: routeName,
      path: routePath,
      builder: (context, state) {
        return this;
      },
    );
  }
}
