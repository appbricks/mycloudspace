
import 'cloud_auth_feature_platform_interface.dart';

class CloudAuthFeature {
  Future<String?> getPlatformVersion() {
    return CloudAuthFeaturePlatform.instance.getPlatformVersion();
  }
}
