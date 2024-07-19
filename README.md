# Example-of-Map-in-Flutter
In this repository, I will introduce you to two of the most popular map packages in Flutter.
- [Google Map](https://pub.dev/packages/google_maps_flutter)
- [Mapbox](https://pub.dev/packages/mapbox_maps_flutter)

Here are the steps for adding Map to Flutter:
## Set up your AndroidManifest.xml
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


