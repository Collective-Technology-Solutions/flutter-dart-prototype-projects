
import 'package:flutter/material.dart';
import 'package:flutter_gps/geo_location_cache.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

List<Marker> buildMarkers( GeoLocationCache cachedLocations, [List<Position> Function()? filter]) {

  List<LatLng> locations = cachedLocations.asLatLng( cachedLocations.getAllFiltered( filter ) );
  List<Marker> results = locations.map((location) {
    return Marker(
      point: location,
      child: Icon(Icons.location_pin, color: Colors.blue, size: 40),
    );
  }).toList();
  return results;
}