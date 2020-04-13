#
# Be sure to run `pod lib lint HumanIDSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HumanIDSDK'
  s.version          = '1.0.0'
  s.summary          = 'HumanIDSDK for iOS.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Bluenumber Foundation HumanID SDK for iOS platform.
                       DESC

  s.homepage         = 'https://github.com/bluenumberfoundation/humanid-ios-sdk'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'GPL', :file => 'LICENSE' }
  s.author           = { 'Bluenumber Foundation' => 'bastian@human-id.org' }
  s.source           = { :git => 'https://github.com/bluenumberfoundation/humanid-ios-sdk.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'
  s.swift_version         = '5.0'

  s.source_files = 'HumanIDSDK/Classes/**/*'

  s.resource_bundles = {
      'Resources' => [
        'HumanIDSDK/Assets/Media.xcassets',
        'HumanIDSDK/Assets/Fonts/*.ttf'
      ]
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  # s.dependency 'AFNetworking', '~> 2.3'

  s.pod_target_xcconfig = {
    'PRODUCT_BUNDLE_IDENTIFIER': 'org.humanid.HumanIDSDK'
  }
end
