import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:platform_utilities_component/platform/app_platform.dart';

class NavLayout extends StatelessWidget {
  /// The navigation shell and container for the branch Navigators
  final StatefulNavigationShell _navShell;

  /// The navigation destinations to render in the navigation bar
  final List<NavDest> _navDests;

  /// Optional app bar to display at the top of the layout
  final TitleBar? _titleBar;

  final bool _bottomNavForMobile;

  const NavLayout(
    StatefulNavigationShell navShell,
    List<NavDest> navDests, {
    super.key,
    TitleBar? titleBar,
    bool bottomNavForMobile = true,
  })  : _navShell = navShell,
        _navDests = navDests,
        _titleBar = titleBar,
        _bottomNavForMobile = bottomNavForMobile;

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

      return !AppPlatform.isMobile && constraints.maxWidth > 600
          ? _getDesktopLayout(theme, appBar)
          : _bottomNavForMobile
              ? _getMobileBottomNavLayout(theme, appBar)
              : _getMobileDrawerNavLayout(theme, appBar);
    });
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

  _getDesktopLayout(ThemeData theme, AppBar? appBar) {
    return Scaffold(
      appBar: appBar,
      body: Row(
        children: [
          SafeArea(
            child: _getNavigationRail(
              theme,
              _navShell.currentIndex,
              _onDestinationSelected,
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
    int selectedIndex,
    void Function(int) onDestinationSelected,
  ) {
    return NavigationRail(
      indicatorColor: theme.colorScheme.primary,
      labelType: NavigationRailLabelType.all,
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      destinations: _navDests.map((navDest) {
        return NavigationRailDestination(
          icon: navDest._icon,
          selectedIcon: navDest._selectedIcon,
          label: Text(navDest._label),
        );
      }).toList(),
    );
  }

  _getMobileBottomNavLayout(ThemeData theme, AppBar? appBar) {
    return Scaffold(
      appBar: appBar,
      bottomNavigationBar: SafeArea(
        child: _getNavigationBar(
          theme,
          _navShell.currentIndex,
          _onDestinationSelected,
        ),
      ),
      body: _navShell,
    );
  }

  _getMobileDrawerNavLayout(ThemeData theme, AppBar? appBar) {
    return Scaffold(
      appBar: appBar,
      bottomNavigationBar: SafeArea(
        child: _getNavigationBar(
          theme,
          _navShell.currentIndex,
          _onDestinationSelected,
        ),
      ),
      body: _navShell,
    );
  }

  NavigationBar _getNavigationBar(
    ThemeData theme,
    int selectedIndex,
    void Function(int) onDestinationSelected,
  ) {
    return NavigationBar(
      indicatorColor: theme.colorScheme.primary,
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      destinations: _navDests.map((navDest) {
        return NavigationDestination(
          selectedIcon: navDest._selectedIcon,
          icon: navDest._icon,
          label: navDest._label,
        );
      }).toList(),
    );
  }

  String _getLabel(int selectedIndex) {
    return _navDests[selectedIndex]._label;
  }
}

class TitleBar {
  final Widget? _leading;
  final List<Widget> _actions;

  const TitleBar({
    Widget? leading,
    List<Widget> actions = const [],
  })  : _leading = leading,
        _actions = actions;
}

class NavDest {
  final Icon _icon;
  final Icon _selectedIcon;
  final String _label;

  NavDest({
    required Icon icon,
    required Icon selectedIcon,
    required String label,
  })  : _icon = icon,
        _selectedIcon = selectedIcon,
        _label = label;
}
