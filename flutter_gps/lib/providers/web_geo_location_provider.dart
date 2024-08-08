import 'package:geolocator/geolocator.dart';
import 'geo_location_provider.dart';

class WebGeoLocationProvider implements GeoLocationProvider {

  //TODO: to plug in settings.isFinePrecision
  @override
  Future<Position> getCurrentLocation() async {
    // Web implementation may vary. This is a placeholder.
    throw UnimplementedError("Web geolocation is not implemented.");
  }
}
