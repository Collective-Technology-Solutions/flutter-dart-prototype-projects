import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/geo_location_cache_provider.dart';

class GPSMapView extends StatelessWidget {
  const GPSMapView({super.key});

  // if used here, we are no longer stateless
  // final Logger _logger = Logger('GPSMapView');

  @override
  Widget build(BuildContext context) {
    final geoLocationCache = Provider.of<GeoLocationCacheProvider>(context);  // to send update notifications via methods
    final position = geoLocationCache.latest;

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
