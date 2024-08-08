import 'package:geolocator/geolocator.dart';

abstract class GeoLocationProvider {
  //TODO: to plug in settings.isFinePrecision
  Future<Position> getCurrentLocation();
}
