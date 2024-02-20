import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'platform_utilities_component_platform_interface.dart';

/// An implementation of [PlatformUtilitiesComponentPlatform] that uses method channels.
class MethodChannelPlatformUtilitiesComponent extends PlatformUtilitiesComponentPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('platform_utilities_component');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
