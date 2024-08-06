import 'package:geolocator/geolocator.dart';
import 'geo_location_provider.dart';

class MobileGeoLocationProvider implements GeoLocationProvider {
  @override
  Future<Position> getCurrentLocation() async {
    // Request permissions and get the current position
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw Exception('Location permission denied');
    }
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}
