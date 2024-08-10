import 'package:geolocator/geolocator.dart';

class MovementSession {
  String name;
  final List<Position> positions;
  final List<double> heartRates;

  MovementSession({
    required this.name,
    required this.positions,
    required this.heartRates
  });
}
