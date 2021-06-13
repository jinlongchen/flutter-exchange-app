#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'flutter_zendesk_support'
  s.version          = '1.0.0'
  s.summary          = 'A Zendesk Support SDK Flutter plugin.'
  s.description      = <<-DESC
  A Zendesk Support SDK Flutter plugin.
                       DESC
  s.homepage         = 'http://skipr.co'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Skipr' => 'skipr@skipr.co' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = '10.0'
  s.ios.deployment_target = '10.0'
  s.static_framework = true

  #s.ios.vendored_frameworks = 'ZendeskSupportSDK/SupportSDK.framework'
  s.dependency 'ZendeskSupportSDK', '~> 5.0.3'
end

