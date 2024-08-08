import 'package:flutter/material.dart';
import 'package:flutter_gps/providers/geo_location_cache_provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:logging/logging.dart';

List<Marker> buildMarkers(GeoLocationCacheProvider cachedLocations,
    [List<Position> Function()? filter]) {
  List<LatLng> locations = cachedLocations
      .getUtils()
      .asLatLngs(cachedLocations.getAllFiltered(filter));
  List<Marker> results = locations.map((location) {
    return Marker(
      point: location,
      child: Icon(
        Icons.location_pin,
        color: Colors.redAccent.shade100,
        size: 20,
      ),
    );
  }).toList();
  var last = results.removeLast();
  results.add(Marker(
    point: last.point,
    child: Icon(Icons.location_pin, color: Colors.red, size: 40),
  ));
  return results;
}

double zoomForCurrent(Position? position) {
  double accuracy = position!.accuracy;
  double result = 13.0;
  if (accuracy < 10)
    result = 5;
  else if (accuracy < 20)
    result = 8;
  else if (accuracy < 40)
    result = 10;
  else if (accuracy < 60)
    result = 13;
  else if (accuracy < 80)
    result = 15;
  else if (accuracy < 90) result = 18;

  final Logger _logger = Logger('zoomForCurrent');
  _logger.info("zoomForCurrent >>> ${accuracy}, $result");

  return result;
}
