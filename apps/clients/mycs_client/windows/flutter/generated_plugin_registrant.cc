//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <amplify_db_common/amplify_db_common_plugin.h>
#include <cloud_auth_feature/cloud_auth_feature_plugin_c_api.h>
#include <cloud_profile_feature/cloud_profile_feature_plugin_c_api.h>
#include <system_tray/system_tray_plugin.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  AmplifyDbCommonPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("AmplifyDbCommonPlugin"));
  CloudAuthFeaturePluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("CloudAuthFeaturePluginCApi"));
  CloudProfileFeaturePluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("CloudProfileFeaturePluginCApi"));
  SystemTrayPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("SystemTrayPlugin"));
}
