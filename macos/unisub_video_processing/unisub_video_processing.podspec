#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint unisub_video_processing.podspec` to validate before publishing.
#

Pod::Spec.new do |s|
  s.name             = 'unisub_video_processing'
  s.version          = '0.0.1'
  s.summary          = 'A Flutter plugin for video processing on macOS'
  s.description      = <<-DESC
A Flutter plugin for video processing on macOS.
                       DESC
  s.homepage         = 'https://github.com/yourcompany/unisub_video_processing'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.dependency 'FlutterMacOS'
  s.platform = :osx, '10.15'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '5.0'
end