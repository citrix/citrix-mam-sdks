# Citrix MAM SDK

The MAM SDK instrument your apps to enable enforcing policies and controls that are configured in Citrix Endpoint Management. The MAM SDK replaces areas of mobile device management not covered by the iOS and Android platforms. Rather than wrapping third-party apps using the MDX Service or MDX Toolkit, you instead create apps using the MAM SDK. 

See the [MAM SDK Overview](https://docs.citrix.com/en-us/mdx-toolkit/mam-sdk-overview.html) for more information.

For more information about the MAM SDK APIs, see the [developer documentation](https://developer.cloud.com/citrixworkspace/mobile-application-integration/).

## Licensing and Agreements

Before you download and utilize the Citrix MAM SDK you must:

* Review the [Citrix License Agreement](https://developer.cloud.com/citrix-api-terms-of-use). By downloading and using the Citrix MAM SDK you agree to these licensing terms.  

## Releases

See the [Releases](https://github.com/citrix/citrix-mam-sdks/releases) for download links to the different MAM SDKs. From GitHub you can recieve email notifications for new releases by clicking on the "Watch" drop-down menu in the upper right-hand corner and selecting Customer -> Releases.

The iOS SDK is also released in a Cocoapod-compatible manner, allowing customers to consume the iOS MAM SDKs in a way that works with the Cocoapod package manager.

Likewise, the Java Android SDK is released in a Maven Repository-compatible manner.  This enables customers to consume the Android MAM SDKs in a way that works with the Gradle or Maven package manager. For example in Gradle's `build.gradle` file you can add the following:
```
android {
    ... snip ...
    repositories {
        maven { url "https://raw.githubusercontent.com/citrix/citrix-mam-sdks/main/maven" }
        google()
        jcenter()
    }
}

dependencies {
    ... snip ...
    implementation group: 'com.citrix.android.sdk', name: 'mamsdk', version: "${project.ext.mamSdkVersion}"
}
```
See the Android Java sample browser app for a complete example.

## Sample Apps

Citrix has open-sourced some sample mobile apps that demonstrate how to use the MAM SDK in your projects.

- [citrix-mam-sdk-sample-browser-app-ios-objc](https://github.com/citrix/citrix-mam-sdk-sample-browser-app-ios-objc)
- [citrix-mam-sdk-sample-browser-app-android-java](https://github.com/citrix/citrix-mam-sdk-sample-browser-app-android-java)
- [citrix-mam-sdk-sample-browser-app-android-xamarin-forms](https://github.com/citrix/citrix-mam-sdk-sample-browser-app-android-xamarin-forms)
- [citrix-mam-sdk-sample-browser-app-android-cordova](https://github.com/citrix/citrix-mam-sdk-sample-browser-app-android-cordova)
