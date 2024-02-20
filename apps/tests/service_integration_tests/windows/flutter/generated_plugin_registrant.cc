//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <amplify_db_common/amplify_db_common_plugin.h>
#include <nav_layouts_component/nav_layouts_component_plugin_c_api.h>
#include <platform_utilities_component/platform_utilities_component_plugin_c_api.h>
#include <screen_retriever/screen_retriever_plugin.h>
#include <window_manager/window_manager_plugin.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  AmplifyDbCommonPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("AmplifyDbCommonPlugin"));
  NavLayoutsComponentPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("NavLayoutsComponentPluginCApi"));
  PlatformUtilitiesComponentPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("PlatformUtilitiesComponentPluginCApi"));
  ScreenRetrieverPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("ScreenRetrieverPlugin"));
  WindowManagerPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("WindowManagerPlugin"));
}
