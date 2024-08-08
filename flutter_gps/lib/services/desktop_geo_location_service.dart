
import 'package:geolocator/geolocator.dart';
import 'geo_location_service.dart';

class DesktopGeoLocationService implements GeoLocationService {
  @override
  Future<Position> getCurrentLocation() async {
    // Desktop implementation may vary. This is a placeholder.

    //TODO: to plug in settings.isFinePrecision
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}
