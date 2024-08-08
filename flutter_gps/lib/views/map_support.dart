import 'dart:convert';

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
  if ( results.isNotEmpty ) {
    var last = results.removeLast();
    results.add(Marker(
      point: last.point,
      child: const Icon(Icons.location_pin, color: Colors.red, size: 40),
    ));
  }
  return results;
}

//TODO: Fix me
String positionAsJson( Position position ) {
  final StringBuffer buffer = StringBuffer();
  var json=position.toJson();
  // json["url"] = positionAsUrl(position);
  // json['id'] = getUserId();
  buffer.write( JsonEncoder.withIndent('  ').convert(json) );
  return buffer.toString();
}

//TODO: Fix me
String positionAsUrl( Position position ) {
  String domain="a";
  double z = zoomForCurrent(position);
  double x = position.latitude;
  double y = position.longitude;
  return 'https://${domain}.tile.openstreetmap.org/${z}/${x}/${y}.png';
}

double zoomForCurrent(Position? position) {
  double result = 13.0;
  if ( position == null) return result;
  double accuracy = position!.accuracy;
  if (accuracy <= 5) {
    result = 2;
  } else if (accuracy <= 20) {
    result = 5;
  } else if (accuracy <= 50) {
    result = 8;
  } else if (accuracy <= 75) {
    result = 10;
  } else if (accuracy <= 100) {
    result = 12;
  }
  else result = 18;

  final Logger logger = Logger('zoomForCurrent');
  logger.info("zoomForCurrent >>> ${accuracy}, $result");

  return result;
}
