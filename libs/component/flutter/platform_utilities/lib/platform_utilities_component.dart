
import 'platform_utilities_component_platform_interface.dart';

class PlatformUtilitiesComponent {
  Future<String?> getPlatformVersion() {
    return PlatformUtilitiesComponentPlatform.instance.getPlatformVersion();
  }
}
