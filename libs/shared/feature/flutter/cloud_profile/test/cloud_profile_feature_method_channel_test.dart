import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_profile_feature/cloud_profile_feature_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelCloudProfileFeature platform = MethodChannelCloudProfileFeature();
  const MethodChannel channel = MethodChannel('cloud_profile_feature');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
