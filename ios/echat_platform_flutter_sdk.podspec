#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint echat_platform_flutter_sdk.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'echat_platform_flutter_sdk'
  s.version          = '0.0.1'
  s.summary          = 'A new EChat Platform Flutter SDK.'
  s.description      = <<-DESC
A new EChat Platform Flutter SDK.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '11.0'
  s.dependency 'EchatPlatformSDK_ncbc'
  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
