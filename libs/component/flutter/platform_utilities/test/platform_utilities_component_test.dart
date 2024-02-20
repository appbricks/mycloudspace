import 'package:flutter_test/flutter_test.dart';
import 'package:platform_utilities_component/platform_utilities_component.dart';
import 'package:platform_utilities_component/platform_utilities_component_platform_interface.dart';
import 'package:platform_utilities_component/platform_utilities_component_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockPlatformUtilitiesComponentPlatform
    with MockPlatformInterfaceMixin
    implements PlatformUtilitiesComponentPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final PlatformUtilitiesComponentPlatform initialPlatform = PlatformUtilitiesComponentPlatform.instance;

  test('$MethodChannelPlatformUtilitiesComponent is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelPlatformUtilitiesComponent>());
  });

  test('getPlatformVersion', () async {
    PlatformUtilitiesComponent platformUtilitiesComponentPlugin = PlatformUtilitiesComponent();
    MockPlatformUtilitiesComponentPlatform fakePlatform = MockPlatformUtilitiesComponentPlatform();
    PlatformUtilitiesComponentPlatform.instance = fakePlatform;

    expect(await platformUtilitiesComponentPlugin.getPlatformVersion(), '42');
  });
}
