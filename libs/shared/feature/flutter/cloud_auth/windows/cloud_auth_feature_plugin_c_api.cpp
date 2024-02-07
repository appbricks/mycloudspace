#include "include/cloud_auth_feature/cloud_auth_feature_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "cloud_auth_feature_plugin.h"

void CloudAuthFeaturePluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  cloud_auth_feature::CloudAuthFeaturePlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
