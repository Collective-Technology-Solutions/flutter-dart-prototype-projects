

// Remove trailing duplicates from the list
import 'package:geolocator/geolocator.dart';

@override
List<Position> removeTrailingDuplicates(List<Position> positions) {
  if (positions.isEmpty) return [];

  final uniquePositions = <Position>[];
  Position? lastPosition;

  for (var position in positions.reversed) {
    if (lastPosition == null ||
        lastPosition.latitude != position.latitude ||
        lastPosition.longitude != position.longitude) {
      uniquePositions.add(position);
      lastPosition = position;
    }
  }
  return uniquePositions.reversed.toList();
}

List<Position> applyQualityDataFilter(List<Position> positions, double accuracyThreshold) {
  if (positions.isEmpty) return [];

  positions = removeTrailingDuplicates(positions);

  List<Position> results = [];
  for (var spot in positions.reversed) {
    if ( spot.altitudeAccuracy < accuracyThreshold ) {
      print("Rejected: altitudeAccuracy ${spot.altitudeAccuracy}");
      continue;
    }
    if ( spot.speedAccuracy < accuracyThreshold ) {
      print("Rejected: speedAccuracy ${spot.altitudeAccuracy}");
      continue;
    }
    results.add( spot);
  }

  return results;
}