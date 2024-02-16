//
//  Generated file. Do not edit.
//

import FlutterMacOS
import Foundation

import amplify_auth_cognito
import amplify_secure_storage
import cloud_auth_feature
import cloud_profile_feature
import device_info_plus
import package_info_plus
import path_provider_foundation
import system_tray

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {
  AmplifyAuthCognitoPlugin.register(with: registry.registrar(forPlugin: "AmplifyAuthCognitoPlugin"))
  AmplifySecureStoragePlugin.register(with: registry.registrar(forPlugin: "AmplifySecureStoragePlugin"))
  CloudAuthFeaturePlugin.register(with: registry.registrar(forPlugin: "CloudAuthFeaturePlugin"))
  CloudProfileFeaturePlugin.register(with: registry.registrar(forPlugin: "CloudProfileFeaturePlugin"))
  DeviceInfoPlusMacosPlugin.register(with: registry.registrar(forPlugin: "DeviceInfoPlusMacosPlugin"))
  FPPPackageInfoPlusPlugin.register(with: registry.registrar(forPlugin: "FPPPackageInfoPlusPlugin"))
  PathProviderPlugin.register(with: registry.registrar(forPlugin: "PathProviderPlugin"))
  SystemTrayPlugin.register(with: registry.registrar(forPlugin: "SystemTrayPlugin"))
}
