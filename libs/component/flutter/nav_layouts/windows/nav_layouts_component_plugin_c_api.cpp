#include "include/nav_layouts_component/nav_layouts_component_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "nav_layouts_component_plugin.h"

void NavLayoutsComponentPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  nav_layouts_component::NavLayoutsComponentPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
