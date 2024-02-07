import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'cloud_auth_feature_platform_interface.dart';

/// An implementation of [CloudAuthFeaturePlatform] that uses method channels.
class MethodChannelCloudAuthFeature extends CloudAuthFeaturePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('cloud_auth_feature');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
