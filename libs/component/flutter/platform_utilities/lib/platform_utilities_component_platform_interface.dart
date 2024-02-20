import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'platform_utilities_component_method_channel.dart';

abstract class PlatformUtilitiesComponentPlatform extends PlatformInterface {
  /// Constructs a PlatformUtilitiesComponentPlatform.
  PlatformUtilitiesComponentPlatform() : super(token: _token);

  static final Object _token = Object();

  static PlatformUtilitiesComponentPlatform _instance = MethodChannelPlatformUtilitiesComponent();

  /// The default instance of [PlatformUtilitiesComponentPlatform] to use.
  ///
  /// Defaults to [MethodChannelPlatformUtilitiesComponent].
  static PlatformUtilitiesComponentPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [PlatformUtilitiesComponentPlatform] when
  /// they register themselves.
  static set instance(PlatformUtilitiesComponentPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
