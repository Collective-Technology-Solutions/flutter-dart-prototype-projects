// lib/views/gps_map_view.dart

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../geo_location_cache.dart';
/*
 1. Obtain a Google Maps API Key

    Go to the Google Cloud Console: Google Cloud Console.
    Create a new project or select an existing one.
    Navigate to the API Library: Find the “Maps SDK for Android” and enable it.
    Go to the Credentials section: Create an API key. Make sure to restrict the key to Android apps to enhance security.

    2. Add the API Key to AndroidManifest.xml

    Open AndroidManifest.xml located in android/app/src/main/.
    Add the meta-data element with your API key inside the <application> tag.

    Here's how to update your AndroidManifest.xml:
 ```
    <!-- Add your API key here -->
    <meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_API_KEY_HERE" />
    ```
    3. Update pubspec.yaml to Ensure Dependencies

    Make sure you have the google_maps_flutter dependency in your pubspec.yaml:
4. Configure Google Maps for Other Platforms

For web and iOS, you’ll need to configure Google Maps separately:

    Web: Follow the Google Maps JavaScript API documentation to add your API key in your web app.

    iOS: You need to add your API key in the AppDelegate.swift file. Add the following line in the application:didFinishLaunchingWithOptions: method:

    swift
```
GMSServices.provideAPIKey("YOUR_API_KEY_HERE")
```
Ensure you import the Google Maps SDK at the top of the file:

swift

import GoogleMaps
 */

class GPSMapView extends StatelessWidget {
  final GeoLocationCache cache;

  const GPSMapView({super.key, required this.cache});

  @override
  Widget build(BuildContext context) {
    final position = cache.latest;

    return Scaffold(
      appBar: AppBar(
        title: const Text("GPS Map"),
      ),
      body: position == null
          ? const Center(child: Text("No location data available"))
          : GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 15,
        ),
        markers: {
          Marker(
            markerId: const MarkerId('current_location'),
            position: LatLng(position.latitude, position.longitude),
            infoWindow: const InfoWindow(title: 'Current Location'),
          ),
        },
        circles: {
          if (position.accuracy < 50)
            Circle(
              circleId: const CircleId('accuracy_circle'),
              center: LatLng(position.latitude, position.longitude),
              radius: position.accuracy,
              fillColor: Colors.blue.withOpacity(0.2),
              strokeColor: Colors.blue,
              strokeWidth: 1,
            ),
        },
      ),
    );
  }
}
