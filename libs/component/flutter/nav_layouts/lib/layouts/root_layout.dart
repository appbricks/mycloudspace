import 'dart:math';
import 'package:flutter/material.dart';

import 'package:platform_utilities_component/platform/app_platform.dart';

class RootLayout extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? splash;

  final bool isSplash;
  final RootViewState state;

  const RootLayout({
    super.key,
    required this.title,
    required this.body,
    this.isSplash = false,
    this.splash,
    this.state = const _DefaultRootViewState(),
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      var showSplash =
          isSplash && !AppPlatform.isMobile && constraints.maxWidth > 600;

      return Stack(
        children: [
          Scaffold(
            appBar: AppPlatform.isMobile
                ? AppBar(
                    title: Text(title),
                  )
                : null,
            body: Row(
              children: [
                if (showSplash) ...[
                  Expanded(
                    child: splash ?? Container(),
                  ),
                  Container(
                    height: constraints.maxHeight,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black38,
                          spreadRadius: 3,
                          blurRadius: 3,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                  ),
                ],
                isSplash
                    ? Container(
                        width: showSplash
                            ? max(constraints.maxWidth / 3, 350)
                            : constraints.maxWidth,
                        constraints: const BoxConstraints(maxWidth: 600),
                        child: body,
                      )
                    : SizedBox(
                        width: constraints.maxWidth,
                        child: body,
                      ),
              ],
            ),
          ),

          // Show a modal progress indicator when waiting.
          if (state.isBusy) ...[
            const Opacity(
              opacity: 0.5,
              child: ModalBarrier(dismissible: false, color: Colors.black),
            ),
            const Center(
              child: CircularProgressIndicator(),
            ),
          ],

          // Show a modal background.
          if (state.isModalBackdrop) ...[
            const Opacity(
              opacity: 0.5,
              child: ModalBarrier(dismissible: false, color: Colors.black),
            ),
          ],
        ],
      );
    });
  }
}

abstract class RootViewState {
  bool get isBusy;
  bool get isModalBackdrop;
}

class _DefaultRootViewState implements RootViewState {
  const _DefaultRootViewState();

  @override
  bool get isBusy => false;

  @override
  bool get isModalBackdrop => false;
}
