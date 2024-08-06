import 'package:geolocator/geolocator.dart';

class GeoLocationCache {
  final List<Position> _locations = [];
  final int _maxSize = 10;

  void add(Position location) {
    if (_locations.length >= _maxSize) {
      _locations.removeAt(0);
    }
    _locations.add(location);
  }

 List<Position> getAll() {
    return _locations;
  }

  Position? get latest => _locations.isNotEmpty ? _locations.last : null;
}
