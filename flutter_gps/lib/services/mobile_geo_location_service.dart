import 'package:geolocator/geolocator.dart';
import 'package:logging/logging.dart';
import 'geo_location_service.dart';

class MobileGeoLocationService implements GeoLocationService {
  final Logger _logger = Logger('MobileGeoLocationProvider');
  
  @override
  Future<Position> getCurrentLocation(LocationAccuracy locationAccuracy) async {
    // Request permissions and get the current position
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw Exception('Location permission denied');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: locationAccuracy,
    );
  }
}
