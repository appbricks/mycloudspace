
import 'cloud_profile_feature_platform_interface.dart';

class CloudProfileFeature {
  Future<String?> getPlatformVersion() {
    return CloudProfileFeaturePlatform.instance.getPlatformVersion();
  }
}
