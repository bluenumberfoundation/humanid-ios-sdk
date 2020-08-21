[![Version](https://img.shields.io/cocoapods/v/HumanIDSDK.svg?style=flat)](https://cocoapods.org/pods/HumanIDSDK)
[![License](https://img.shields.io/cocoapods/l/HumanIDSDK.svg?style=flat)](https://cocoapods.org/pods/HumanIDSDK)
[![Platform](https://img.shields.io/cocoapods/p/HumanIDSDK.svg?style=flat)](https://cocoapods.org/pods/HumanIDSDK)

# humanID iOS SDK

<p align="center">
<img src="https://user-images.githubusercontent.com/2031493/80385493-4f1b8480-88d0-11ea-8110-ab62c747a997.png" width="200" height="200">

<p align="center">
<a href="https://github.com/bluenumberfoundation/humanid-documentation">General Documentation</a> •
<a href="https://github.com/bluenumberfoundation/humanid-ios-sdk/wiki">Wiki</a> • 
<a href="https://github.com/bluenumberfoundation/humanid-ios-sdk/wiki/integration">Integration</a> • 
<a href="https://github.com/bluenumberfoundation/humanid-documentation/blob/master/contributing.md">Contributing</a> • 
<a href="https://github.com/bluenumberfoundation/humanid-documentation/blob/master/gallery.md">Gallery</a> • 
<a href="https://github.com/bluenumberfoundation/humanid-documentation/blob/master/faq.md">FAQ</a>

<p align="center">
Meet humanID - An anonymous online identity, enabling platforms to offer the speed and comfort of social logins, while guaranteeing absolute privacy and protecting our communities by permanently blocking bots, spams, and trolls.
</p>

## Requirements

* Xcode 11.4+
* Swift 5.0
* iOS 11.0+
* [Clean Swift](https://clean-swift.com) VIP architecture

***Please update to the latest SDK!***

## Built with

* [Swinject](https://github.com/Swinject/Swinject) - Dependency injection framework for Swift with iOS/macOS/Linux
* [RxSwift](https://github.com/ReactiveX/RxSwift) - Reactive Programming in Swift
* [RxAlamofire](https://github.com/RxSwiftCommunity/RxAlamofire) - RxSwift wrapper around the elegant HTTP networking in Swift Alamofire
* [FlagPhoneNumber](https://github.com/chronotruck/FlagPhoneNumber) - A formatted phone number UITextField with country flag picker.
* [VKPinCodeView](https://github.com/Sunspension/VKPinCodeView) - VKPinCodeView is simple and elegant UI component for input PIN. You can easily customise appearance and get auto fill (OTP) iOS 12 feature right from the box.
* [IQKeyboardManager](https://github.com/hackiftekhar/IQKeyboardManager) - Codeless drop-in universal library allows to prevent issues of keyboard sliding up and cover UITextField/UITextView. Neither need to write any code nor any setup required and much more.
* [PodAsset](https://github.com/haifengkao/PodAsset) - Unable to find cocoapods resources? Here is the solution!

## Installation

HumanIDSDK is available through [CocoaPods](https://cocoapods.org).\
To install it, simply add the following line to your Podfile:

```ruby
pod 'HumanIDSDK'
```

## Get the credentials access

Get the clientId and clientSecret by dropping us an email [developers@human-id.org](mailto:developers@human-id.org).

## Configuration

Add these codes into your `AppDelegate.swift` and make sure all value is fulfilled.

```swift
import HumanIDSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
     HumanIDSDK.shared.configure(clientID: "YOUR_CLIENT_ID", clientSecret: "YOUR_CLIENT_SECRET")
  }
}
```

## How do I use iOS SDK

Add these codes into your ViewController file, we recommend you wrap this in a function that handles the login button.

```swift
import HumanIDSDK

class YourViewController: UIViewController {

  @IBAction func yourLoginAction(_ sender: Any) {
     HumanIDSDK.shared.requestOtp(from: self, name: "YOUR_APPLICATION_NAME", image: "YOUR_APPLICATION_LOGO")
  }
}

extension YourViewController: RequestOTPDelegate {

  func login(with token: String) {
     // TODO You can persist our token here.
  }
}
```

## You are set!

Now you can integrate your iOS app to humanID. See the full [sample](https://github.com/bluenumberfoundation/humanid-ios-sdk/tree/master/Example) here to learn more.

**Warning!**
To run the example project, clone the repo, and run `pod install` from the Example directory first.

## License

Copyright 2019-2020 Bluenumber Foundation\
Licensed under the GNU General Public License v3.0 [(LICENSE)](https://github.com/bluenumberfoundation/humanid-ios-sdk/blob/master/LICENSE)
