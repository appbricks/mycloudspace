import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:nav_layouts_component/layouts/root_layout.dart';
import 'package:nav_layouts_component/layouts/nav_layout.dart';
import 'package:nav_layouts_component/navigation/navigable_widget.dart';

abstract class RootNavLayout implements Navigable {
  @override
  String get routeName {
    assert(navTargets.isNotEmpty);
    return navTargets[0]._body.routeName;
  }

  @override
  String get routePath {
    assert(navTargets.isNotEmpty);
    return navTargets[0]._body.routeName;
  }

  /// The navigation targets to route nav menu selections
  List<NavTarget> get navTargets;

  /// Optional navigation bar at bottom of layout or as a drawer
  final bool bottomNavForMobile;

  /// The root view title
  final String title;

  /// The navigation destinations to create nav menu items
  List<NavDest> buildNavDests(BuildContext context);

  /// Optional app bar to display at the top of the layout
  NavTitleBar? buildNavTitleBar(BuildContext context) {
    return null;
  }

  /// The root view state
  final RootViewState state;

  const RootNavLayout(
    this.title,
    this.state, {
    this.bottomNavForMobile = true,
  });

  @override
  RouteBase route() {
    return StatefulShellRoute.indexedStack(
      builder: (context, navState, navShell) {
        final navTitleBar = buildNavTitleBar(context);
        final navDests = buildNavDests(context);
        if (navDests.length != navTargets.length) {
          throw StateError('Nav dests and targets must be the same length');
        }

        return RootLayout(
          body: NavLayout(
            navShell,
            navDests,
            titleBar: navTitleBar,
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

class NavTarget {
  final NavigableWidget _body;

  NavTarget({
    required NavigableWidget body,
  }) : _body = body;
}

final _sectionNavigatorKey = GlobalKey<NavigatorState>();
