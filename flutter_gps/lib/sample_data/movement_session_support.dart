
import 'dart:math';

import 'package:flutter_gps/models/movement_session.dart';
import 'package:flutter_gps/utils/movement_support.dart';
import 'package:geolocator/geolocator.dart';

int _count = 1;
int _intRadius = 50;
int _max = 5;

MovementSession createSampleSession(MovementType type) {
  final String name = "Session ${++_count}";
  final int numPositions = 120; // Number of positions to simulate
  final double radius = 50.0*(_count); // 50 meters radius for the circular path
  final double centerLatitude = 37.7749; // Central point latitude (e.g., San Francisco)
  final double centerLongitude = -122.4194; // Central point longitude
  final double maxSpeedMph;
  final double minSpeedMph = 0.0; // Min speed in miles per hour (standing still)
  final double maxAltitude = 1000.0; // Maximum altitude in meters
  final double minAltitude = 0.0; // Minimum altitude in meters
  final double maxAccuracy = 10.0; // Maximum accuracy in meters
  final double minAccuracy = 1.0; // Minimum accuracy in meters

  // Determine speeds based on movement type
  switch (type) {
    case MovementType.standing:
      maxSpeedMph = 0.0;
      break;
    case MovementType.walking:
      maxSpeedMph = 5.0;
      break;
    case MovementType.running:
      maxSpeedMph = 10.0;
      break;
    case MovementType.bicycling:
      maxSpeedMph = 20.0;
      break;
    case MovementType.automobile:
      maxSpeedMph = 120.0;
      break;
    case MovementType.unknown:
      maxSpeedMph = -1;
  }

  final double maxSpeedMs = maxSpeedMph * 0.44704; // Convert mph to m/s

  // Generate a list of positions
  List<Position> positions = [];
  List<double> heartRates = [];
  double totalDistanceTraveled = 0.0; // Initialize the distance accumulator

  double angleIncrement = 2 * pi / numPositions; // Full circle divided by number of positions
  double timeIncrement = 1.0; // seconds between each position
  double currentSpeedMs = 0.0;

  Position? previousPosition;

  for (int i = 0; i < numPositions; i++) {
    double angle = angleIncrement * i;
    double latitude = centerLatitude + (radius / 111320) * cos(angle); // 111320 meters per degree latitude
    double longitude = centerLongitude + (radius / (111320 * cos(centerLatitude * pi / 180))) * sin(angle);

    // Simulate speed changes
    if (i < numPositions / 2) {
      currentSpeedMs = (i / (numPositions / 2)) * maxSpeedMs; // Accelerate
    } else {
      currentSpeedMs = maxSpeedMs - ((i - numPositions / 2) / (numPositions / 2)) * maxSpeedMs; // Decelerate
    }

    // Simulate altitude changes
    double altitude = minAltitude + (maxAltitude - minAltitude) * (i / numPositions);

    // Simulate heading (direction)
    double heading = (angle * 180 / pi) % 360; // Convert radians to degrees

    // Simulate accuracy changes
    double accuracy = minAccuracy + (maxAccuracy - minAccuracy) * (i / numPositions);

    // Add Position object to list
    Position currentPosition = (Position(
      latitude: latitude,
      longitude: longitude,
      timestamp: DateTime.now().add(Duration(seconds: i * timeIncrement.toInt())),
      altitude: altitude,
      accuracy: accuracy,
      speed: currentSpeedMs, // Speed in meters per second
      heading: heading,  // Heading in degrees
      altitudeAccuracy: 1.0,
      headingAccuracy: 1.0,
      speedAccuracy: 1.0,
    ));


    // Add Position object to list
    positions.add(currentPosition);

    // Simulate heart rate changes with acceleration
    double heartRate = 60 + (currentSpeedMs / maxSpeedMs) * 100; // Basic heart rate simulation
    heartRates.add(heartRate);

    // Update the previous position
    previousPosition = currentPosition;
  }

  return MovementSession(
    name: name,
    positions: positions,
    heartRates: heartRates
  );
}

// Haversine formula to calculate distance between two points
double calculateDistance(Position p1, Position p2) {
  const double earthRadius = 6371000; // meters
  double lat1 = p1.latitude * pi / 180;
  double lon1 = p1.longitude * pi / 180;
  double lat2 = p2.latitude * pi / 180;
  double lon2 = p2.longitude * pi / 180;

  double dLat = lat2 - lat1;
  double dLon = lon2 - lon1;

  double a = sin(dLat / 2) * sin(dLat / 2) +
      cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
  double c = 2 * atan2(sqrt(a), sqrt(1 - a));

  return earthRadius * c; // Distance in meters
}