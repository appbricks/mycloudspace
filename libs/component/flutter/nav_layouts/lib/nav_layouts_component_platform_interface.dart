import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'nav_layouts_component_method_channel.dart';

abstract class NavLayoutsComponentPlatform extends PlatformInterface {
  /// Constructs a NavLayoutsComponentPlatform.
  NavLayoutsComponentPlatform() : super(token: _token);

  static final Object _token = Object();

  static NavLayoutsComponentPlatform _instance = MethodChannelNavLayoutsComponent();

  /// The default instance of [NavLayoutsComponentPlatform] to use.
  ///
  /// Defaults to [MethodChannelNavLayoutsComponent].
  static NavLayoutsComponentPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [NavLayoutsComponentPlatform] when
  /// they register themselves.
  static set instance(NavLayoutsComponentPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
