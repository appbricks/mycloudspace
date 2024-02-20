import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nav_layouts_component/nav_layouts_component_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelNavLayoutsComponent platform = MethodChannelNavLayoutsComponent();
  const MethodChannel channel = MethodChannel('nav_layouts_component');

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
