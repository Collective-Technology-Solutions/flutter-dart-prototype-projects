
import 'package:geolocator/geolocator.dart';
import 'geo_location_service.dart';

class DesktopGeoLocationService implements GeoLocationService {

  @override
  Future<Position> getCurrentLocation(LocationAccuracy locationAccuracy) async {
    // Get the current position with the desired accuracy
    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: locationAccuracy,
        timeLimit:Duration(seconds: 3), //TODO configurable?
        forceAndroidLocationManager: true,
      );
    } catch (e) {
      // Handle the error, e.g., permissions not granted, etc.
      print('Error getting current location: $e');
      rethrow; // or handle it according to your app's needs
    }
  }
}