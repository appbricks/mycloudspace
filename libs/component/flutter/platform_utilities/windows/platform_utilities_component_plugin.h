#ifndef FLUTTER_PLUGIN_PLATFORM_UTILITIES_COMPONENT_PLUGIN_H_
#define FLUTTER_PLUGIN_PLATFORM_UTILITIES_COMPONENT_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace platform_utilities_component {

class PlatformUtilitiesComponentPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  PlatformUtilitiesComponentPlugin();

  virtual ~PlatformUtilitiesComponentPlugin();

  // Disallow copy and assign.
  PlatformUtilitiesComponentPlugin(const PlatformUtilitiesComponentPlugin&) = delete;
  PlatformUtilitiesComponentPlugin& operator=(const PlatformUtilitiesComponentPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace platform_utilities_component

#endif  // FLUTTER_PLUGIN_PLATFORM_UTILITIES_COMPONENT_PLUGIN_H_
