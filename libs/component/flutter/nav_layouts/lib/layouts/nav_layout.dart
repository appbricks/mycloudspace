import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:platform_utilities_component/platform/app_platform.dart';

class NavLayout extends StatelessWidget {
  /// The navigation shell and container for the branch Navigators
  final StatefulNavigationShell _navShell;

  /// The navigation destinations to render in the navigation bar
  final List<NavDest> _navDests;

  /// Optional app bar to display at the top of the layout
  final NavTitleBar? _titleBar;

  final NavProperties _navProperties;

  const NavLayout(
    StatefulNavigationShell navShell,
    List<NavDest> navDests, {
    super.key,
    NavTitleBar? titleBar,
    NavTypeFn? navTypeFn,
    NavProperties navProperties = const NavProperties(),
  })  : _navShell = navShell,
        _navDests = navDests,
        _titleBar = titleBar,
        _navProperties = navProperties;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final ThemeData theme = Theme.of(context);

      AppBar? appBar;
      if (_titleBar != null) {
        appBar = AppBar(
          backgroundColor: theme.colorScheme.primaryContainer,
          title: Text(
            _getLabel(_navShell.currentIndex),
            style: theme.textTheme.titleLarge,
          ),
          centerTitle: true,
          leading: _titleBar._leading,
          actions: _titleBar._actions,
        );
      }

      NavType navType;
      if (_navProperties.navTypeFn == null) {
        navType = _determineNavType(context, constraints);
      } else {
        navType = _navProperties.navTypeFn!(context, constraints);
      }
      return switch (navType) {
        NavType.bottomNav => _getMobileBottomNavLayout(
            theme,
            constraints,
            appBar,
          ),
        NavType.drawerNav => _getMobileDrawerNavLayout(
            theme,
            appBar,
          ),
        _ => _getDesktopLayout(theme, appBar, navType),
      };
    });
  }

  NavType _determineNavType(BuildContext context, BoxConstraints constraints) {
    print('constraints.maxWidth: ${constraints.maxWidth}');
    if (AppPlatform.isMobile) {
      if (constraints.maxWidth < 600) {
        return _navProperties.bottomNavForMobile
            ? NavType.bottomNav
            : NavType.drawerNav;
      }
    } else {
      if (constraints.maxWidth < 600) {
        return _navProperties.bottomNavForMobile
            ? NavType.bottomNav
            : NavType.drawerNav;
      } else if (constraints.maxWidth >= 1024) {
        return NavType.expandedNav;
      }
    }
    return NavType.compactNav;
  }

  void _onDestinationSelected(int index) {
    _navShell.goBranch(
      index,
      // A common pattern when using bottom navigation bars is to support
      // navigating to the initial location when tapping the item that is
      // already active. This example demonstrates how to support this behavior,
      // using the initialLocation parameter of goBranch.
      initialLocation: index == _navShell.currentIndex,
    );
  }

  Widget _getDesktopLayout(
    ThemeData theme,
    AppBar? appBar,
    NavType navType,
  ) {
    return Scaffold(
      appBar: appBar,
      body: Row(
        children: [
          SafeArea(
            child: _getNavigationRail(
              theme,
              navType,
            ),
          ),
          Expanded(
            child: _navShell,
          )
        ],
      ),
    );
  }

  NavigationRail _getNavigationRail(
    ThemeData theme,
    NavType navType,
  ) {
    bool extended;
    double top, left, height;
    NavigationRailLabelType? labelType;

    if (navType == NavType.expandedNav) {
      extended = true;
      top = -24;
      left = -24;
      height = 80.0;
    } else {
      extended = false;
      labelType = NavigationRailLabelType.all;
      top = -16;
      left = -24;
      height = 72.0;
    }

    return NavigationRail(
      selectedIndex: _navShell.currentIndex,
      onDestinationSelected: _onDestinationSelected,
      extended: extended,
      minExtendedWidth: _navProperties.minExtendedWidth,
      labelType: labelType,
      destinations: _navDests.map((navDest) {
        return NavigationRailDestination(
          icon: navDest._icon ??
              Icon(
                navDest._iconData,
              ),
          selectedIcon: navDest._selectedIcon ??
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: top,
                    left: left,
                    child: SizedBox(
                      width: 4,
                      height: height,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: top,
                    left: left + 4,
                    child: SizedBox(
                      width: _navProperties.minExtendedWidth,
                      height: height,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: theme.canvasColor,
                        ),
                      ),
                    ),
                  ),
                  Icon(
                    navDest._selectedIconData,
                  ),
                ],
              ),
          label: Text(
            navDest._label,
          ),
        );
      }).toList(),
    );
  }

  Widget _getMobileBottomNavLayout(
    ThemeData theme,
    BoxConstraints constraints,
    AppBar? appBar,
  ) {
    return Scaffold(
      appBar: appBar,
      bottomNavigationBar: SafeArea(
        child: _getNavigationBar(
          theme,
          constraints,
          _navShell.currentIndex,
          _onDestinationSelected,
        ),
      ),
      body: _navShell,
    );
  }

  Widget _getNavigationBar(
    ThemeData theme,
    BoxConstraints constraints,
    int selectedIndex,
    void Function(int) onDestinationSelected,
  ) {
    double itemWidth = constraints.maxWidth / _navDests.length;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: 0,
          left: 0,
          child: Container(
            color: theme.colorScheme.surface,
            child: SizedBox(
              width: constraints.maxWidth,
              height: 76,
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: selectedIndex * itemWidth,
          child: SizedBox(
            width: itemWidth,
            height: 76,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: theme.canvasColor,
              ),
            ),
          ),
        ),
        NavigationBar(
          indicatorColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          selectedIndex: selectedIndex,
          onDestinationSelected: onDestinationSelected,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          destinations: _navDests.map((navDest) {
            return NavigationDestination(
              icon: navDest._icon ??
                  Icon(
                    navDest._iconData,
                  ),
              selectedIcon: navDest._selectedIcon ??
                  Icon(
                    navDest._selectedIconData,
                    color: theme.colorScheme.primary,
                  ),
              label: navDest._label,
            );
          }).toList(),
        ),
        Positioned(
          top: 76,
          left: selectedIndex * itemWidth,
          child: SizedBox(
            width: itemWidth,
            height: 4,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _getMobileDrawerNavLayout(
    ThemeData theme,
    AppBar? appBar,
  ) {
    return const Placeholder();
  }

  String _getLabel(int selectedIndex) {
    return _navDests[selectedIndex]._label;
  }
}

class NavProperties {
  final double minExtendedWidth;
  final bool bottomNavForMobile;
  final NavTypeFn? navTypeFn;

  const NavProperties({
    this.minExtendedWidth = 168.0,
    this.bottomNavForMobile = true,
    this.navTypeFn,
  });
}

class NavTitleBar {
  final Widget? _leading;
  final List<Widget> _actions;

  const NavTitleBar({
    Widget? leading,
    List<Widget> actions = const [],
  })  : _leading = leading,
        _actions = actions;
}

class NavDest {
  final Widget? _icon;
  final Widget? _selectedIcon;
  final IconData? _iconData;
  final IconData? _selectedIconData;
  final String _label;

  NavDest({
    Widget? icon,
    Widget? selectedIcon,
    IconData? iconData,
    IconData? selectedIconData,
    required String label,
  })  : assert(icon != null || iconData != null),
        assert(selectedIcon != null || selectedIconData != null),
        _icon = icon,
        _iconData = iconData,
        _selectedIcon = selectedIcon,
        _selectedIconData = selectedIconData,
        _label = label;
}

typedef NavTypeFn = NavType Function(
  BuildContext context,
  BoxConstraints constraints,
);

enum NavType {
  drawerNav,
  bottomNav,
  compactNav,
  expandedNav,
}
