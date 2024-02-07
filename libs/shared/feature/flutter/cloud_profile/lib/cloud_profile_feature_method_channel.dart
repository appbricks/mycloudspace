import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'cloud_profile_feature_platform_interface.dart';

/// An implementation of [CloudProfileFeaturePlatform] that uses method channels.
class MethodChannelCloudProfileFeature extends CloudProfileFeaturePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('cloud_profile_feature');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
