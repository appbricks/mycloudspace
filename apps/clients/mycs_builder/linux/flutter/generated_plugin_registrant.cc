//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <cloud_auth_feature/cloud_auth_feature_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) cloud_auth_feature_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "CloudAuthFeaturePlugin");
  cloud_auth_feature_plugin_register_with_registrar(cloud_auth_feature_registrar);
}
