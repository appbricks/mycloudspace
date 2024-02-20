import 'package:flutter_test/flutter_test.dart';
import 'package:nav_layouts_component/nav_layouts_component.dart';
import 'package:nav_layouts_component/nav_layouts_component_platform_interface.dart';
import 'package:nav_layouts_component/nav_layouts_component_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockNavLayoutsComponentPlatform
    with MockPlatformInterfaceMixin
    implements NavLayoutsComponentPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final NavLayoutsComponentPlatform initialPlatform = NavLayoutsComponentPlatform.instance;

  test('$MethodChannelNavLayoutsComponent is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelNavLayoutsComponent>());
  });

  test('getPlatformVersion', () async {
    NavLayoutsComponent navLayoutsComponentPlugin = NavLayoutsComponent();
    MockNavLayoutsComponentPlatform fakePlatform = MockNavLayoutsComponentPlatform();
    NavLayoutsComponentPlatform.instance = fakePlatform;

    expect(await navLayoutsComponentPlugin.getPlatformVersion(), '42');
  });
}
