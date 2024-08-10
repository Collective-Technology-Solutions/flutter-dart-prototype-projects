import 'package:geolocator/geolocator.dart';

abstract class GeoLocationService {
  //TODO: to plug in settings.isFinePrecision
  Future<Position> getCurrentLocation(LocationAccuracy locationAccuracy);
}
