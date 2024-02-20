import 'package:flutter/material.dart';

import 'package:platform_utilities_component/platform/app_platform.dart';

class AppLayout extends StatefulWidget {
  final AppNav _appNav;

  const AppLayout(
    AppNav appNav, {
    super.key,
  }) : _appNav = appNav;

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  int currentPageIndex = 0;

  void onDestinationSelected(int index) {
    setState(() {
      currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    var appBar = AppBar(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      title: Text(
        widget._appNav._getLabel(currentPageIndex),
        style: theme.textTheme.titleLarge,
      ),
      centerTitle: true,
      leading: Padding(
        padding: const EdgeInsets.fromLTRB(23.0, 8.0, 8.0, 8.0),
        child: Image.asset(
          "assets/letter-assist-icon.png",
          fit: BoxFit.fitHeight,
        ),
      ),
      actions: [
        MenuAnchor(
          builder: (
            BuildContext context,
            MenuController controller,
            Widget? child,
          ) {
            return IconButton(
              onPressed: () {
                if (controller.isOpen) {
                  controller.close();
                } else {
                  controller.open();
                }
              },
              icon: Icon(
                Icons.menu,
                color: theme.textTheme.titleLarge?.color,
              ),
            );
          },
          menuChildren: [
            MenuItemButton(
              leadingIcon: const Icon(
                Icons.logout,
              ),
              child: const Text('Logout'),
              onPressed: () {
                // widget._appState.authState.logout();
              },
            ),
          ],
        ),
      ],
    );

    return LayoutBuilder(builder: (context, constraints) {
      return !AppPlatform.isMobile && constraints.maxWidth > 600
          ? _getDesktopLayout(context, appBar)
          : _getMobileLayout(context, appBar);
    });
  }

  _getDesktopLayout(BuildContext context, AppBar appBar) {
    return Scaffold(
      appBar: appBar,
      body: Row(
        children: [
          SafeArea(
            child: widget._appNav._getNavigationRail(
              Theme.of(context),
              currentPageIndex,
              onDestinationSelected,
            ),
          ),
          Expanded(
            child: widget._appNav._getPage(currentPageIndex),
          )
        ],
      ),
    );
  }

  _getMobileLayout(BuildContext context, AppBar appBar) {
    return Scaffold(
      appBar: appBar,
      bottomNavigationBar: SafeArea(
        child: widget._appNav._getNavigationBar(
          Theme.of(context),
          currentPageIndex,
          onDestinationSelected,
        ),
      ),
      body: widget._appNav._getPage(currentPageIndex),
    );
  }
}

class AppNav {
  final List<NavDest> _navDests;

  AppNav(
    List<NavDest> navDests,
  ) : _navDests = navDests;

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

  String _getLabel(int selectedIndex) {
    return _navDests[selectedIndex]._label;
  }

  Widget _getPage(int selectedIndex) {
    return _navDests[selectedIndex]._page;
  }
}

class NavDest {
  final Icon _icon;
  final Icon _selectedIcon;
  final String _label;
  final Widget _page;

  NavDest({
    required Icon icon,
    required Icon selectedIcon,
    required String label,
    required Widget page,
  })  : _icon = icon,
        _selectedIcon = selectedIcon,
        _label = label,
        _page = page;
}
