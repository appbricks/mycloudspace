#include "include/cloud_profile_feature/cloud_profile_feature_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "cloud_profile_feature_plugin.h"

void CloudProfileFeaturePluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  cloud_profile_feature::CloudProfileFeaturePlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
