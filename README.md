# Example-of-Map-in-Flutter
In this repository, I will introduce you to two of the most popular map packages in Flutter.
- [Google Map](https://pub.dev/packages/google_maps_flutter)
- [Mapbox](https://pub.dev/packages/mapbox_gl)

## 1. Adding Google Map to Flutter:
## Adding Google Maps Flutter plugin as a dependency
```sh
flutter pub add google_maps_flutter
```
## Add your API key to app
### Android App 
To add an API key to the Android app, edit the AndroidManifest.xml file in android/app/src/main. Add a single meta-data entry containing the API key created in the previous step inside the application node.
```sh
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <application
        android:label="google_maps_in_flutter"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher">

        <!-- TODO: Add your Google Maps API key here -->
        <meta-data android:name="com.google.android.geo.API_KEY"
               android:value="YOUR-KEY-HERE"/>
   ....
   </application>
   ....
</manifest>
```
In case, you want to access the user location please add this permission to your AndroidManifest.xml file 
```sh
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    .....
</manifest>
```
### IOS App
- To add an API key to the iOS app, edit the AppDelegate.swift file in ios/Runner. Unlike Android, adding an API key on iOS requires changes to the source code of the Runner app. The AppDelegate is the core singleton that is part of the app initialization process.
- Make two changes to this file. First, add an #import statement to pull in the Google Maps headers, and then call the provideAPIKey() method of the GMSServices singleton. This API key enables Google Maps to correctly serve map tiles.
```sh
import Flutter
import UIKit
import GoogleMaps                                          // Add this import

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // TODO: Add your Google Maps API key
    GMSServices.provideAPIKey("YOUR-API-KEY")               // Add this line

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```
## Configure IOS platform and Android minSDK (optional)
To get the latest version of the Google Maps SDK on your app, requires a platform minimum version of iOS 14 and minSDK 21.
### android/app/build.gradle
```sh
android {
    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.google_maps_in_flutter"
        // Minimum Android version for Google Maps SDK
        // https://developers.google.com/maps/flutter-package/config#android
        minSdk = 21
        targetSdk = flutter.targetSdkVersion
        versionCode = flutterVersionCode.toInteger()
        versionName = flutterVersionName
    }

}
```
### ios/Podfile
```sh
# Google Maps SDK requires platform version 14
# https://developers.google.com/maps/flutter-package/config#ios
platform :ios, '14.0'
```
## 2.Adding Mapbox to your app
## Add your secret token
### Android app
- Find or create a gradle.properties file locate in «USER_HOME»/.gradle
- Add your secret access token to your gradle
```sh
SDK_REGISTRY_TOKEN=YOUR_SECRET_MAPBOX_ACCESS_TOKEN
```
### IOS app
- To use your secret token, you will need to store it in a .netrc file in your home directory (not your project folder).Depending on your environment, you may have this file already, so check first before creating a new one.
- #### The .netrc file needs 0600 permissions to work properly.
- If you are having trouble with your .netrc file or the secret access token, follow our [detailed instructions](https://docs.mapbox.com/ios/maps/guides/install/#step-3-configure-your-secret-token).
```sh
machine api.mapbox.com
login mapbox
password YOUR_SECRET_MAPBOX_ACCESS_TOKEN
```
## Configure your public token
You can then pass your token to the environment when building, running, or launching the application:
```sh
// Build or run from the command line:
flutter build <platform> --dart-define ACCESS_TOKEN=...
flutter run --dart-define ACCESS_TOKEN=...

// Add your token in launch.json: 
"configurations": [
    {
        ...
        "args": [
            "--dart-define", "ACCESS_TOKEN=..."
        ],
    }
]
```
Then, retrieve the token from the environment in the application and set it via MapboxOptions:
```sh
String ACCESS_TOKEN = String.fromEnvironment("ACCESS_TOKEN");
MapboxOptions.setAccessToken(ACCESS_TOKEN);
```
Or you can use [.env](https://pub.dev/packages/flutter_dotenv) file to hide your public access token.
## Add the dependency
```sh
flutter pub add mapbox_gl
```




