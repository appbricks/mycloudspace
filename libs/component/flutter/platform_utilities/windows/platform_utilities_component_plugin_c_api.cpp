#include "include/platform_utilities_component/platform_utilities_component_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "platform_utilities_component_plugin.h"

void PlatformUtilitiesComponentPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  platform_utilities_component::PlatformUtilitiesComponentPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
