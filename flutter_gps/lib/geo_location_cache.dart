import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class GeoLocationCache {
  final List<Position> _locations = [];
  final int _maxSize = 100;

  bool testData = false;
  int driftCount = -1;
  double driftValue = .05;

  Position? getCurrent() {
    return _locations.last;
  }

  LatLng getCurrentAsLatLgn() {
    return _locations.isNotEmpty ? LatLng(_locations.last.latitude,_locations.last.longitude) : LatLng(0, 0);
  }

  void add(Position location) {
    if (_locations.length >= _maxSize) {
      _locations.removeAt(0);
    }

    Position p;
    if ( testData && ++driftCount != 0 ) {
       var map = location.toJson();
       // Assuming 'map' is a Map<String, dynamic> and 'location.latitude + driftValue' is the new value.
       map.update(
           'latitude',
               (existingValue) => (existingValue as double) + (driftCount* driftValue),
           ifAbsent: () => location.latitude + driftValue // Optional: Define the value if the key doesn't exist
       );
      p = Position.fromMap(map);
    } else p = location;
    _locations.add(p);
  }

 List<Position> getAll() {
    return _locations;
  }

  
  List<Position> getOverView() {
    return getAllFiltered( this.removeTrailingDuplicates);
  }

  List<Position> getAllFiltered([List<Position> Function()? filter]) {
    if (filter == null) {
      return getAll();
    }
    return filter();
  }

  // Remove trailing duplicates from the list
  List<Position> removeTrailingDuplicates() {
    if (_locations.isEmpty) return [];

    final uniquePositions = <Position>[];
    Position? lastPosition;

    for (var position in _locations.reversed) {
      if (lastPosition == null ||
          lastPosition.latitude != position.latitude ||
          lastPosition.longitude != position.longitude) {
        uniquePositions.add(position);
        lastPosition = position;
      }
    }
    return uniquePositions.reversed.toList();
  }

  List<LatLng> asLatLng(List<Position> positions) {
    return positions.map( (p) => LatLng(p.latitude,p.longitude) ).toList();
  }

  Position? get latest => _locations.isNotEmpty ? _locations.last : null;
}
