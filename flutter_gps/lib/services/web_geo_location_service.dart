import 'package:geolocator/geolocator.dart';
import 'geo_location_service.dart';

class WebGeoLocationService implements GeoLocationService {

  //TODO: to plug in settings.isFinePrecision
  @override
  Future<Position> getCurrentLocation() async {
    // Web implementation may vary. This is a placeholder.
    throw UnimplementedError("Web geolocation is not implemented.");
  }
}
