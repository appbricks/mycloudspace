import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_profile_feature/cloud_profile_feature.dart';
import 'package:cloud_profile_feature/cloud_profile_feature_platform_interface.dart';
import 'package:cloud_profile_feature/cloud_profile_feature_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockCloudProfileFeaturePlatform
    with MockPlatformInterfaceMixin
    implements CloudProfileFeaturePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final CloudProfileFeaturePlatform initialPlatform = CloudProfileFeaturePlatform.instance;

  test('$MethodChannelCloudProfileFeature is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelCloudProfileFeature>());
  });

  test('getPlatformVersion', () async {
    CloudProfileFeature cloudProfileFeaturePlugin = CloudProfileFeature();
    MockCloudProfileFeaturePlatform fakePlatform = MockCloudProfileFeaturePlatform();
    CloudProfileFeaturePlatform.instance = fakePlatform;

    expect(await cloudProfileFeaturePlugin.getPlatformVersion(), '42');
  });
}
