
import 'nav_layouts_component_platform_interface.dart';

class NavLayoutsComponent {
  Future<String?> getPlatformVersion() {
    return NavLayoutsComponentPlatform.instance.getPlatformVersion();
  }
}
