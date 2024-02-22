import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:nav_layouts_component/nav_layouts.dart';

class AppState extends ChangeNotifier implements RootViewState {
  @override
  bool get isBusy => _isBusy;
  bool _isBusy = false;

  @override
  bool get isModalBackdrop => _isModalBackdrop;
  bool _isModalBackdrop = false;

  static final rootNavigatorKey = GlobalKey<NavigatorState>();

  void setBusy(bool value) {
    _isBusy = value;
    notifyListeners();
  }

  void setModalBackdrop() {
    _isModalBackdrop = true;
    notifyListeners();
  }

  void resetModalBackdrop() {
    _isModalBackdrop = false;
    notifyListeners();
  }

  void navigateTo(String name) {
    rootNavigatorKey.currentContext!.goNamed(name);
  }
}
