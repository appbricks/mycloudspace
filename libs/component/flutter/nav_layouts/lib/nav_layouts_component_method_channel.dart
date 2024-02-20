import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'nav_layouts_component_platform_interface.dart';

/// An implementation of [NavLayoutsComponentPlatform] that uses method channels.
class MethodChannelNavLayoutsComponent extends NavLayoutsComponentPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('nav_layouts_component');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
