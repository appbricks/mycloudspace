//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <amplify_db_common/amplify_db_common_plugin.h>
#include <cloud_auth_feature/cloud_auth_feature_plugin.h>
#include <cloud_profile_feature/cloud_profile_feature_plugin.h>
#include <system_tray/system_tray_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) amplify_db_common_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "AmplifyDbCommonPlugin");
  amplify_db_common_plugin_register_with_registrar(amplify_db_common_registrar);
  g_autoptr(FlPluginRegistrar) cloud_auth_feature_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "CloudAuthFeaturePlugin");
  cloud_auth_feature_plugin_register_with_registrar(cloud_auth_feature_registrar);
  g_autoptr(FlPluginRegistrar) cloud_profile_feature_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "CloudProfileFeaturePlugin");
  cloud_profile_feature_plugin_register_with_registrar(cloud_profile_feature_registrar);
  g_autoptr(FlPluginRegistrar) system_tray_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "SystemTrayPlugin");
  system_tray_plugin_register_with_registrar(system_tray_registrar);
}
