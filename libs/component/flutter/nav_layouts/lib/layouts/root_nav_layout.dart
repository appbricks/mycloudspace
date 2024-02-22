import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:nav_layouts_component/layouts/root_layout.dart';
import 'package:nav_layouts_component/layouts/nav_layout.dart';
import 'package:nav_layouts_component/navigation/navigable_widget.dart';

abstract class RootNavLayout implements Navigable {
  @override
  String get routeName {
    if (navTargets.isNotEmpty) {
      return navTargets[0]._body.routeName;
    }
    throw StateError('No navigation targets defined');
  }

  @override
  String get routePath {
    if (navTargets.isNotEmpty) {
      return navTargets[0]._body.routeName;
    }
    throw StateError('No navigation targets defined');
  }

  /// The navigation targets to create ui and routes for
  List<NavTarget> get navTargets;

  /// Optional app bar to display at the top of the layout
  TitleBar? get titleBar => null;

  /// Optional navigation bar at bottom of layout or as a drawer
  bool get bottomNavForMobile => true;

  /// The root view title
  final String title;

  /// The root view state
  final RootViewState state;

  const RootNavLayout(this.title, this.state);

  @override
  RouteBase route() {
    return StatefulShellRoute.indexedStack(
      builder: (context, navState, navShell) {
        return RootLayout(
          body: NavLayout(
            navShell,
            navTargets,
            titleBar: titleBar,
            bottomNavForMobile: bottomNavForMobile,
          ),
          title: title,
          state: state,
        );
      },
      branches: navTargets.map((navTarget) {
        if (routeName == navTarget._body.routeName) {
          return StatefulShellBranch(
            navigatorKey: _sectionNavigatorKey,
            routes: [
              navTarget._body.route(),
            ],
          );
        } else {
          return StatefulShellBranch(
            routes: [
              navTarget._body.route(),
            ],
          );
        }
      }).toList(),
    );
  }
}

class NavTarget extends NavDest {
  final NavigableWidget _body;

  NavTarget({
    required super.icon,
    required super.selectedIcon,
    required super.label,
    required NavigableWidget body,
  }) : _body = body;
}

final _sectionNavigatorKey = GlobalKey<NavigatorState>();
