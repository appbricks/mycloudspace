import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'cloud_auth_feature_method_channel.dart';

abstract class CloudAuthFeaturePlatform extends PlatformInterface {
  /// Constructs a CloudAuthFeaturePlatform.
  CloudAuthFeaturePlatform() : super(token: _token);

  static final Object _token = Object();

  static CloudAuthFeaturePlatform _instance = MethodChannelCloudAuthFeature();

  /// The default instance of [CloudAuthFeaturePlatform] to use.
  ///
  /// Defaults to [MethodChannelCloudAuthFeature].
  static CloudAuthFeaturePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [CloudAuthFeaturePlatform] when
  /// they register themselves.
  static set instance(CloudAuthFeaturePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
