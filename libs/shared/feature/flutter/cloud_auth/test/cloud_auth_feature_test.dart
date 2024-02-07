import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_auth_feature/cloud_auth_feature.dart';
import 'package:cloud_auth_feature/cloud_auth_feature_platform_interface.dart';
import 'package:cloud_auth_feature/cloud_auth_feature_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockCloudAuthFeaturePlatform
    with MockPlatformInterfaceMixin
    implements CloudAuthFeaturePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final CloudAuthFeaturePlatform initialPlatform = CloudAuthFeaturePlatform.instance;

  test('$MethodChannelCloudAuthFeature is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelCloudAuthFeature>());
  });

  test('getPlatformVersion', () async {
    CloudAuthFeature cloudAuthFeaturePlugin = CloudAuthFeature();
    MockCloudAuthFeaturePlatform fakePlatform = MockCloudAuthFeaturePlatform();
    CloudAuthFeaturePlatform.instance = fakePlatform;

    expect(await cloudAuthFeaturePlugin.getPlatformVersion(), '42');
  });
}
