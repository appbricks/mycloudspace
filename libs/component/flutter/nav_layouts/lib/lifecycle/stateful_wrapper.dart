import 'package:flutter/material.dart';

// use this wrapper to wrap widgets that need to
// handle initialization and dispose events during
// the widget lifecycle
class StatefulWrapper extends StatefulWidget {
  final Function? onInit;
  final Function? onDespose;
  final Widget child;

  const StatefulWrapper({
    super.key,
    this.onInit,
    this.onDespose,
    required this.child,
  });

  @override
  State<StatefulWrapper> createState() => _StatefulWrapperState();
}

class _StatefulWrapperState extends State<StatefulWrapper> {
  @override
  void initState() {
    if (widget.onInit != null) {
      widget.onInit!();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void dispose() {
    if (widget.onDespose != null) {
      widget.onDespose!();
    }
    super.dispose();
  }
}
