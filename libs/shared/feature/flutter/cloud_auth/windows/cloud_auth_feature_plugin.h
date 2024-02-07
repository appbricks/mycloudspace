#ifndef FLUTTER_PLUGIN_CLOUD_AUTH_FEATURE_PLUGIN_H_
#define FLUTTER_PLUGIN_CLOUD_AUTH_FEATURE_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace cloud_auth_feature {

class CloudAuthFeaturePlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  CloudAuthFeaturePlugin();

  virtual ~CloudAuthFeaturePlugin();

  // Disallow copy and assign.
  CloudAuthFeaturePlugin(const CloudAuthFeaturePlugin&) = delete;
  CloudAuthFeaturePlugin& operator=(const CloudAuthFeaturePlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace cloud_auth_feature

#endif  // FLUTTER_PLUGIN_CLOUD_AUTH_FEATURE_PLUGIN_H_
