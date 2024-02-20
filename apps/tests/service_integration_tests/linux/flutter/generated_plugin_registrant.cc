//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <amplify_db_common/amplify_db_common_plugin.h>
#include <nav_layouts_component/nav_layouts_component_plugin.h>
#include <platform_utilities_component/platform_utilities_component_plugin.h>
#include <screen_retriever/screen_retriever_plugin.h>
#include <window_manager/window_manager_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) amplify_db_common_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "AmplifyDbCommonPlugin");
  amplify_db_common_plugin_register_with_registrar(amplify_db_common_registrar);
  g_autoptr(FlPluginRegistrar) nav_layouts_component_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "NavLayoutsComponentPlugin");
  nav_layouts_component_plugin_register_with_registrar(nav_layouts_component_registrar);
  g_autoptr(FlPluginRegistrar) platform_utilities_component_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "PlatformUtilitiesComponentPlugin");
  platform_utilities_component_plugin_register_with_registrar(platform_utilities_component_registrar);
  g_autoptr(FlPluginRegistrar) screen_retriever_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "ScreenRetrieverPlugin");
  screen_retriever_plugin_register_with_registrar(screen_retriever_registrar);
  g_autoptr(FlPluginRegistrar) window_manager_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "WindowManagerPlugin");
  window_manager_plugin_register_with_registrar(window_manager_registrar);
}
