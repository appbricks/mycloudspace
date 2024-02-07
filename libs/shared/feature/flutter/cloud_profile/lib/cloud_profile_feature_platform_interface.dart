import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'cloud_profile_feature_method_channel.dart';

abstract class CloudProfileFeaturePlatform extends PlatformInterface {
  /// Constructs a CloudProfileFeaturePlatform.
  CloudProfileFeaturePlatform() : super(token: _token);

  static final Object _token = Object();

  static CloudProfileFeaturePlatform _instance = MethodChannelCloudProfileFeature();

  /// The default instance of [CloudProfileFeaturePlatform] to use.
  ///
  /// Defaults to [MethodChannelCloudProfileFeature].
  static CloudProfileFeaturePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [CloudProfileFeaturePlatform] when
  /// they register themselves.
  static set instance(CloudProfileFeaturePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
