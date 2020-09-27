Pod::Spec.new do |s|
  s.name                  = 'HumanIDSDK'
  s.version               = '1.4.0'
  s.summary               = 'HumanIDSDK for iOS.'

  s.description           = <<-DESC
  Bluenumber Foundation HumanID SDK for iOS platform.
                            DESC

  s.homepage              = 'https://github.com/bluenumberfoundation/humanid-ios-sdk'
  s.license               = { :type => 'GPL', :file => 'LICENSE' }
  s.author                = { 'Bluenumber Foundation' => 'developers@human-id.org' }
  s.source                = { :git => 'https://github.com/bluenumberfoundation/humanid-ios-sdk.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'
  s.swift_version         = '5.0'

  s.subspec 'Sources' do |spec|
    spec.source_files     = 'HumanIDSDK/Classes/**/*.{swift}'
  end

  s.resource_bundles      = { 'HumanIDSDK' => ['HumanIDSDK/Assets/**/*.{ttf,xcassets,xib,strings}'] }

  s.frameworks            = 'UIKit'
  s.dependency 'Swinject', '2.7.1'
  s.dependency 'RxAlamofire', '5.6.1'
  s.dependency 'RxCocoa', '5.1.1'
  s.dependency 'RxSwift', '5.1.1'
  s.dependency 'FlagPhoneNumber', '0.8.0'
  s.dependency 'IQKeyboardManager', '6.5.6'
  s.dependency 'VKPinCodeView', '0.4.2'

  s.pod_target_xcconfig   = {
    'MARKETING_VERSION' => s.version.to_s,
    'CURRENT_PROJECT_VERSION' => '1',
    'BASE_URL' => 'https:/$()/core.human-id.org/v0.0.3/',
    'SANDBOX_URL' => 'https:/$()/sandbox.human-id.org/v0.0.3/',
    'WEB_URL' => 'https:/$()/human-id.org/privacy-policy/',
    'INFOPLIST_FILE' => '${PODS_TARGET_SRCROOT}/HumanIDSDK/Assets/Info.plist'
  }
end
