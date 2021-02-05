# SwissPassClient SDK v3 for iOS

Copyright (C) Schweizerische Bundesbahnen SBB, 2016-2021

## Overview

Using the SwissPassClient SDK your app can take advantage of SwissPass services for mobile apps, such as SwissPass Login and SwissPass Mobile. 

### SwissPass Login

SwissPass Login for mobile apps is based on OAuth 2.0, which is the industry-standard protocol for authorization on mobile devices. 

As such, the SwissPassClient SDK implements the security requirements and other recommendations for mobile applications as described in RFC 8252 "OAuth 2.0 for Native Apps". For example, this includes PKCE according to RFC 7636 "Proof Key for Code Exchange" which is an extension to the Authorization Code flow to prevent several attacks and to be able to securely perform the OAuth exchange from public clients.

In addition, please note the following:

* If your app wants to access a protected resource using an access token issued by the SwissPass Login server it must follow the principles described in RFC 6750 "The OAuth 2.0 Authorization Framework: Bearer Token Usage". Particularly, the app must correctly implement the error handling.
* Access tokens are now by default JSON Web Tokens according to RFC 7519 "JSON Web Token (JWT)". As a consequence, they can either be validated by implementing the checks described in RFC 7519 or by using the SwissPass Login token introspection endpoint, which is based on RFC 7662 "OAuth 2.0 Token Introspection".
* Starting with version 3.0 the SwissPassClient SDK uses OpenID Connect (OIDC) Core 1.0 which is an identity layer on top of the OAuth 2.0 protocol. However, it does not yet expose the ID token issued by the SwissPass Login server.

### SwissPass Mobile

SwissPass Mobile enables travelers to display public transport travelcards conveniently on a digital device. 

* SwissPass Mobile can be integrated into your app in 2 different ways, either as a fullscreen representation using the `SwissPassMobileViewController` or embedded in a custom screen of your app using the `SwissPassMobileCardViewController`. 
* SwissPass Mobile can be activated by the user in up to 3 different apps simultaneously. In case of a forth activation, the first activation will be deleted automatically.
* When performing a logout operation, an existing SwissPass Mobile will not be deactivated until another user performs a login operation in the same app. In this case, the existing SwissPassMobile will be deactivated automatically.

## How to use the SDK

The SwissPassClient SDK is written in Swift 5 and compiled using the option *Build Libraries for Distribution* with deployment target is iOS 11. It is distributed as XCFramework and supports Bitcode. 

In addition:

* Make sure to integrate the *Swift Standard Libraries* in your build. I.e., the option *Embedded Content Contains Swift Code* (EMBEDDED_CONTENT_CONTAINS_SWIFT) must be set to YES.
* In order to use FaceID in `requestAuthentication()` be sure to specify the key `NSFaceIDUsageDescription` in your info.plist - for more details see https://developer.apple.com/documentation/localauthentication/lacontext

### Swift Package Manager

The SDK can be integrated into your build process as an XCFramework using the Swift Package Manager. To do so, just add the package by using the following url

```
https://github.com/SchweizerischeBundesbahnen/SwissPassSDK-iOS.git
```

### CocoaPods

The SDK can be integrated into your build process as a framework using CocoaPods.

```
platform :ios, '11.0'
inhibit_all_warnings!

source 'https://github.com/SchweizerischeBundesbahnen/SBBCocoaPods-Ext.git'

target 'MyAppUsingSwissPassClient' do
pod 'SwissPassClient', '~> 3.0.0'
end
```

## Additional information

Further documentation is available on the NOVA UserGroup website.

### Contact

General inquiries, suggestions and feedback can be made via the NOVA UserGroup website or the SwissPass Alliance.

### Example

A demo app is available in source form on https://github.com/SchweizerischeBundesbahnen/SwissPassSDK-iOS.
