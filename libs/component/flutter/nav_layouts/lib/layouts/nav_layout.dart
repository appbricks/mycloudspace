import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:platform_utilities_component/platform/app_platform.dart';

class NavLayout extends StatefulWidget {
  /// The navigation shell and container for the branch Navigators
  final StatefulNavigationShell _navShell;

  /// The navigation destinations to render in the navigation bar
  final List<NavDest> _navDests;

  /// Optional app bar to display at the top of the layout
  final NavTitleBar? _titleBar;

  /// Optional navigation properties to customize the layout navigation ui
  final NavProperties _navProperties;

  final NavTypeFn? _navTypeFn;
  final BuildNavTrailWidgetFn? _buildNavTrailLeadingWidgetFn;
  final BuildNavTrailWidgetFn? _buildNavTrailTrailingWidgetFn;
  final BuildNavDrawerWidgetFn? _buildNavDrawerHeaderWidgetFn;

  const NavLayout(
    StatefulNavigationShell navShell,
    List<NavDest> navDests, {
    super.key,
    NavTitleBar? titleBar,
    NavTypeFn? navTypeFn,
    BuildNavTrailWidgetFn? buildNavTrailLeadingWidgetFn,
    BuildNavTrailWidgetFn? buildNavTrailTrailingWidgetFn,
    BuildNavDrawerWidgetFn? buildNavDrawerHeaderWidgetFn,
    NavProperties navProperties = const NavProperties(),
  })  : _navShell = navShell,
        _navDests = navDests,
        _titleBar = titleBar,
        _navProperties = navProperties,
        _navTypeFn = navTypeFn,
        _buildNavTrailLeadingWidgetFn = buildNavTrailLeadingWidgetFn,
        _buildNavTrailTrailingWidgetFn = buildNavTrailTrailingWidgetFn,
        _buildNavDrawerHeaderWidgetFn = buildNavDrawerHeaderWidgetFn;

  @override
  State<StatefulWidget> createState() => _NavLayout();
}

class _NavLayout extends State<NavLayout> {
  // indicates if the navigation rail is extended or drawer is open
  bool isExtended = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final ThemeData theme = Theme.of(context);

      NavType navType;
      if (widget._navTypeFn == null) {
        navType = _determineNavType(context, constraints);
      } else {
        navType = widget._navTypeFn!(context, constraints);
      }
      return switch (navType) {
        NavType.bottomNav => _buildMobileBottomNavLayout(
            constraints,
            theme,
            _buildAppBar(theme, true),
          ),
        NavType.drawerNav => _buildMobileDrawerNavLayout(
            context,
            constraints,
            theme,
            _buildAppBar(theme, false),
          ),
        _ => _buildDesktopLayout(
            context,
            constraints,
            theme,
            navType,
            _buildAppBar(theme, true),
          ),
      };
    });
  }

  NavType _determineNavType(BuildContext context, BoxConstraints constraints) {
    if (AppPlatform.isMobile) {
      if (constraints.maxWidth < 600) {
        return widget._navProperties.mobileNavType == MobileNavType.bottom
            ? NavType.bottomNav
            : NavType.drawerNav;
      }
    } else {
      if (constraints.maxWidth < 600) {
        return widget._navProperties.mobileNavType == MobileNavType.bottom
            ? NavType.bottomNav
            : NavType.drawerNav;
      } else if ((widget._navProperties.showExtended == ShowExtended.dynamic &&
              isExtended) ||
          (widget._navProperties.showExtended != ShowExtended.dynamic &&
              constraints.maxWidth >= 1024)) {
        return NavType.extendedNav;
      }
    }
    return NavType.compactNav;
  }

  AppBar? _buildAppBar(
    ThemeData theme,
    bool showLeading,
  ) {
    if (widget._titleBar != null) {
      return AppBar(
        backgroundColor: theme.colorScheme.primaryContainer,
        title: Text(
          _getLabel(widget._navShell.currentIndex),
          style: theme.textTheme.titleLarge,
        ),
        centerTitle: true,
        leading: showLeading ? widget._titleBar?._leading : null,
        actions: widget._titleBar?._actions,
      );
    } else {
      return null;
    }
  }

  Widget _buildDesktopLayout(
    BuildContext context,
    BoxConstraints constraints,
    ThemeData theme,
    NavType navType,
    AppBar? appBar,
  ) {
    final isExtended = navType == NavType.extendedNav;

    return Scaffold(
      appBar: appBar,
      body: Row(
        children: [
          SafeArea(
            child: _getNavigationRail(
              theme,
              isExtended,
              widget._buildNavTrailLeadingWidgetFn != null
                  ? widget._buildNavTrailLeadingWidgetFn!(
                      context,
                      constraints,
                      isExtended,
                    )
                  : null,
              widget._buildNavTrailTrailingWidgetFn != null
                  ? widget._buildNavTrailTrailingWidgetFn!(
                      context,
                      constraints,
                      isExtended,
                    )
                  : null,
            ),
          ),
          Expanded(
            child: widget._navShell,
          )
        ],
      ),
    );
  }

  NavigationRail _getNavigationRail(
    ThemeData theme,
    bool isExtended,
    Widget? leading,
    Widget? trailing,
  ) {
    bool extended;
    double top, left, height;
    NavigationRailLabelType? labelType;

    if (isExtended) {
      extended = true;
      top = -24;
      left = -24;
      height = 80.0;
    } else {
      extended = false;

      switch (widget._navProperties.showLabels) {
        case ShowLabels.never || ShowLabels.whenExtended:
          labelType = NavigationRailLabelType.none;
          top = -24;
          left = -24;
          height = 72.0;
          break;
        case ShowLabels.always:
          labelType = NavigationRailLabelType.all;
          top = -16;
          left = -24;
          height = 72.0;
          break;
      }
    }

    return NavigationRail(
      selectedIndex: widget._navShell.currentIndex,
      onDestinationSelected: _onDestinationSelected,
      extended: extended,
      minExtendedWidth: widget._navProperties.minExtendedWidth,
      labelType: labelType,
      leading: leading,
      trailing: widget._navProperties.showExtended == ShowExtended.dynamic
          ? _resizeNavigationRailButton(theme, extended, trailing)
          : trailing,
      destinations: widget._navDests.map((navDest) {
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
                      width: widget._navProperties.minExtendedWidth,
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

  Widget _resizeNavigationRailButton(
    ThemeData theme,
    bool extended,
    Widget? trailing,
  ) {
    final color = theme.colorScheme.onSurface.withOpacity(0.6);
    return Expanded(
      child: Column(
        children: [
          const Expanded(child: SizedBox()),
          if (trailing != null) trailing,
          Container(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: color,
                  width: 1.0,
                ),
              ),
            ),
            child: Row(
              children: [
                if (extended)
                  SizedBox(
                    width: widget._navProperties.minExtendedWidth - 76,
                  ),
                IconButton(
                  icon: Icon(
                    extended
                        ? widget._navProperties.collapseIcon
                        : widget._navProperties.expandIcon,
                    color: color,
                  ),
                  onPressed: () => setState(() {
                    isExtended = !isExtended;
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileBottomNavLayout(
    BoxConstraints constraints,
    ThemeData theme,
    AppBar? appBar,
  ) {
    return Scaffold(
      appBar: appBar,
      bottomNavigationBar: SafeArea(
        child: _getNavigationBar(
          theme,
          constraints,
          widget._navShell.currentIndex,
          _onDestinationSelected,
        ),
      ),
      body: widget._navShell,
    );
  }

  Widget _getNavigationBar(
    ThemeData theme,
    BoxConstraints constraints,
    int selectedIndex,
    void Function(int) onDestinationSelected,
  ) {
    double itemWidth = constraints.maxWidth / widget._navDests.length;

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
              height: 80,
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: selectedIndex * itemWidth,
          child: SizedBox(
            width: itemWidth,
            height: 80,
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
          labelBehavior: widget._navProperties.showLabels == ShowLabels.always
              ? NavigationDestinationLabelBehavior.alwaysShow
              : NavigationDestinationLabelBehavior.alwaysHide,
          destinations: widget._navDests.map((navDest) {
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

  Widget _buildMobileDrawerNavLayout(
    BuildContext context,
    BoxConstraints constraints,
    ThemeData theme,
    AppBar? appBar,
  ) {
    return Scaffold(
      appBar: appBar,
      drawer: _getDrawerNavLayout(context, constraints, theme),
      body: widget._navShell,
    );
  }

  Widget _getDrawerNavLayout(
    BuildContext context,
    BoxConstraints constraints,
    ThemeData theme,
  ) {
    final header = widget._buildNavDrawerHeaderWidgetFn != null
        ? widget._buildNavDrawerHeaderWidgetFn!(
            context,
            constraints,
          )
        : null;

    final leadingOption = widget._titleBar?._leading != null
        ? <Widget>[
            const SizedBox(
              height: 8,
            ),
            widget._titleBar!._leading!,
            const SizedBox(
              height: 2,
            ),
            Divider(
              height: header == null ? 10 : 0,
              thickness: 1,
            ),
          ]
        : null;

    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
      ),
      width: widget._navProperties.minExtendedWidth,
      child: Column(
        children: [
          if (leadingOption != null) ...leadingOption,
          if (header != null) header,
          Expanded(
            child: ListView(
              children: widget._navDests.map((navDest) {
                return ListTile(
                  leading: navDest._icon ??
                      Icon(
                        navDest._iconData,
                      ),
                  title: Text(
                    navDest._label,
                  ),
                  selected: widget._navShell.currentIndex ==
                      widget._navDests.indexOf(navDest),
                  onTap: () {
                    _onDestinationSelected(widget._navDests.indexOf(navDest));
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  String _getLabel(int selectedIndex) {
    return widget._navDests[selectedIndex]._label;
  }

  void _onDestinationSelected(int index) {
    widget._navShell.goBranch(
      index,
      // A common pattern when using bottom navigation bars is to support
      // navigating to the initial location when tapping the item that is
      // already active. This example demonstrates how to support this behavior,
      // using the initialLocation parameter of goBranch.
      initialLocation: index == widget._navShell.currentIndex,
    );
  }
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

class NavProperties {
  final MobileNavType mobileNavType;
  final double minExtendedWidth;
  final IconData expandIcon;
  final IconData collapseIcon;
  final ShowExtended showExtended;
  final ShowLabels showLabels;

  const NavProperties({
    this.mobileNavType = MobileNavType.bottom,
    this.minExtendedWidth = 168.0,
    this.expandIcon = Icons.arrow_forward,
    this.collapseIcon = Icons.arrow_back,
    this.showExtended = ShowExtended.always,
    this.showLabels = ShowLabels.always,
  }) : assert(showExtended == ShowExtended.never ||
            showLabels != ShowLabels.never);
}

enum NavType {
  drawerNav,
  bottomNav,
  compactNav,
  extendedNav,
}

enum MobileNavType {
  bottom,
  drawer,
}

enum ShowExtended {
  never,
  dynamic,
  always,
}

enum ShowLabels {
  never,
  always,
  whenExtended,
}

typedef NavTypeFn = NavType Function(
  BuildContext context,
  BoxConstraints constraints,
);

typedef BuildNavTrailWidgetFn = Widget? Function(
  BuildContext context,
  BoxConstraints constraints,
  bool isExtended,
);

typedef BuildNavDrawerWidgetFn = Widget? Function(
  BuildContext context,
  BoxConstraints constraints,
);
