#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint nav_layouts_component.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'nav_layouts_component'
  s.version          = '0.0.1'
  s.summary          = 'Common layouts with built in navigation capabilities'
  s.description      = <<-DESC
Common layouts with built in navigation capabilities
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }

  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.dependency 'FlutterMacOS'

  s.platform = :osx, '10.11'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '5.0'
end
