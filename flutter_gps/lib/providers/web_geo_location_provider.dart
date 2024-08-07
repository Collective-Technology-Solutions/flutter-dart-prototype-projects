import 'package:geolocator/geolocator.dart';
import 'geo_location_provider.dart';

class WebGeoLocationProvider implements GeoLocationProvider {
  @override
  Future<Position> getCurrentLocation() async {
    // Web implementation may vary. This is a placeholder.
    throw UnimplementedError("Web geolocation is not implemented.");
  }
}
