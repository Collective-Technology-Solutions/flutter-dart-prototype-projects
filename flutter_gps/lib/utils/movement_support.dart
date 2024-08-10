import 'dart:math';

import 'package:flutter_gps/models/movement_session.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logging/logging.dart';

enum MovementType { standing, walking, running, bicycling, automobile, unknown }

class MovementMetrics {
  final double averageAccuracy;
  final double minSpeed;
  final double maxSpeed;
  final double averageSpeed;
  final double totalDistance;
  final Map<String, double> speedTimePercentages;
  final MovementType movementType;
  final double caloriesBurnedRangeMin;
  final double caloriesBurnedRangeMax;
  final double totalTimeInEachMovementType;
  final double elevationChangeMin;
  final double elevationChangeMax;
  final double averageElevationChange;
  final double heartRateCaloriesBurned;

  MovementMetrics({
    required this.averageAccuracy,
    required this.minSpeed,
    required this.maxSpeed,
    required this.averageSpeed,
    required this.totalDistance,
    required this.speedTimePercentages,
    required this.movementType,
    required this.caloriesBurnedRangeMin,
    required this.caloriesBurnedRangeMax,
    required this.totalTimeInEachMovementType,
    required this.elevationChangeMin,
    required this.elevationChangeMax,
    required this.averageElevationChange,
    required this.heartRateCaloriesBurned,
  });

  Map<String, dynamic> toJson() => {
        'averageAccuracy': averageAccuracy,
        'minSpeed': minSpeed,
        'maxSpeed': maxSpeed,
        'averageSpeed': averageSpeed,
        'totalDistance': totalDistance,
        'speedTimePercentages': speedTimePercentages,
        'movementType': movementType.toString(),
        'caloriesBurnedRange': {
          'min': caloriesBurnedRangeMin,
          'max': caloriesBurnedRangeMax,
        },
        'totalTimeInEachMovementType': totalTimeInEachMovementType,
        'elevationChange': {
          'min': elevationChangeMin,
          'max': elevationChangeMax,
          'average': averageElevationChange,
        },
        'heartRateCaloriesBurned': heartRateCaloriesBurned,
      };
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

double calculateAverageAccuracy(List<Position> positions) {
  double totalAccuracy = positions.fold(0, (sum, pos) => sum + pos.accuracy);
  return totalAccuracy / positions.length;
}

Map<String, double> calculateSpeedTimePercentages(
    List<Position> positions, double totalTime) {
  int numSpeedIntervals = 5;
  List<double> speedIntervals =
      List.generate(numSpeedIntervals, (i) => i * 5.0);
  List<double> speedTimeCounts = List.generate(numSpeedIntervals, (i) => 0);

  for (int i = 0; i < positions.length - 1; i++) {
    Position current = positions[i];
    Position next = positions[i + 1];

    double distance = Geolocator.distanceBetween(
      current.latitude,
      current.longitude,
      next.latitude,
      next.longitude,
    );
    double timeDiff =
        next.timestamp.difference(current.timestamp).inSeconds.toDouble();
    double speed = distance / timeDiff;

    int speedIntervalIndex =
        speedIntervals.indexWhere((interval) => speed <= interval);
    if (speedIntervalIndex == -1) {
      speedIntervalIndex = numSpeedIntervals - 1;
    }
    speedTimeCounts[speedIntervalIndex] += timeDiff;
  }

  return {
    for (int i = 0; i < numSpeedIntervals; i++)
      'Speed ${speedIntervals[i]} m/s': (speedTimeCounts[i] / totalTime) * 100,
  };
}

double calculateCaloriesBurned(double speed, double time) {
  // Simplified estimate: Calories burned = speed (m/s) * time (s) * weight (kg) * 0.0175
  // Assuming average weight of 70 kg
  return speed * time * 70 * 0.0175;
}

MovementType determineMovementType(double averageSpeed) {
  if (averageSpeed < 1.0) {
    return MovementType.standing;
  } else if (averageSpeed < 5.0) {
    return MovementType.walking;
  } else if (averageSpeed < 10.0) {
    return MovementType.running;
  } else if (averageSpeed < 20.0) {
    return MovementType.bicycling;
  } else {
    return MovementType.automobile;
  }
}

double calculateCaloriesFromHeartRate(
    List<double> heartRates, double totalTime) {
  if (heartRates.isEmpty) return 0.0;
  double averageHeartRate =
      heartRates.reduce((a, b) => a + b) / heartRates.length;
  return averageHeartRate * totalTime * 0.0175; // Example calculation
}

Map<String, dynamic> generateMovementMetrics(MovementSession session) {
  List<Position> positions = session.positions;
  List<double> heartRates = session.heartRates;

  if (positions.isEmpty) {
    return {};
  }

  // Metrics calculation
  double averageAccuracy = calculateAverageAccuracy(positions);
  double minSpeed = double.infinity;
  double maxSpeed = 0;
  double totalSpeed = 0;
  double totalDistance = 0;
  double totalTime = 0;
  double totalCaloriesBurned = 0;
  double totalHeartRateCaloriesBurned = 0;
  double totalElevationChange = 0;
  double elevationChangeMin = double.infinity;
  double elevationChangeMax = -double.infinity;
  double previousElevation = positions[0].altitude ?? 0;

  Position? previousPosition;

  try {
    Position? previousPosition;
    for (int i = 0; i < positions.length - 1; i++) {
      Position current = positions[i];
      Position next = positions[i + 1];

      double distance = Geolocator.distanceBetween(
        current.latitude,
        current.longitude,
        next.latitude,
        next.longitude,
      );
      double timeDiff =
          next.timestamp.difference(current.timestamp).inSeconds.toDouble();
      double speed = distance / timeDiff;

      minSpeed = speed < minSpeed ? speed : minSpeed;
      maxSpeed = speed > maxSpeed ? speed : maxSpeed;
      totalSpeed += speed;

      totalDistance += distance;
      totalTime += timeDiff;

      // Calculate elevation change
      double currentElevation = next.altitude ?? previousElevation;
      double elevationChange = (currentElevation - previousElevation).abs();
      elevationChangeMin = elevationChange < elevationChangeMin
          ? elevationChange
          : elevationChangeMin;
      elevationChangeMax = elevationChange > elevationChangeMax
          ? elevationChange
          : elevationChangeMax;
      totalElevationChange += elevationChange;
      previousElevation = currentElevation;

      // Example calories burned calculation
      totalCaloriesBurned += calculateCaloriesBurned(speed, timeDiff);

    }

    double averageSpeed = totalSpeed / (positions.length - 1);
    double averageElevationChange =
        totalElevationChange / (positions.length - 1);
    Map<String, double> speedTimePercentages =
        calculateSpeedTimePercentages(positions, totalTime);

    MovementType movementType = determineMovementType(averageSpeed);

    // Calories burned range calculation
    double caloriesBurnedRangeMin = totalCaloriesBurned * 0.9;
    double caloriesBurnedRangeMax = totalCaloriesBurned * 1.1;

    // Calculate heart rate calories burned if heart rates are provided
    totalHeartRateCaloriesBurned =
        calculateCaloriesFromHeartRate(heartRates, totalTime);

    MovementMetrics metrics = MovementMetrics(
      averageAccuracy: averageAccuracy,
      minSpeed: minSpeed,
      maxSpeed: maxSpeed,
      averageSpeed: averageSpeed,
      totalDistance: totalDistance,
      speedTimePercentages: speedTimePercentages,
      movementType: movementType,
      caloriesBurnedRangeMin: caloriesBurnedRangeMin,
      caloriesBurnedRangeMax: caloriesBurnedRangeMax,
      totalTimeInEachMovementType: totalTime,
      elevationChangeMin: elevationChangeMin,
      elevationChangeMax: elevationChangeMax,
      averageElevationChange: averageElevationChange,
      heartRateCaloriesBurned: totalHeartRateCaloriesBurned,
    );
    return metrics.toJson();
  } catch (e) {
    Logger _logger = Logger('generateMovementMetrics');
    _logger.severe(e);
    return Map();
  }
}

String convertDistance(double meters, {bool useImperial = false}) {
  if (useImperial) {
    // Convert to miles if using imperial units
    double miles = meters * 0.000621371;
    if (miles < 1) {
      // Convert to feet if less than 1 mile
      double feet = miles * 5280;
      return '${feet.toStringAsFixed(2)} feet';
    } else {
      return '${miles.toStringAsFixed(2)} miles';
    }
  } else {
    // Metric units
    if (meters < 1000) {
      return '${meters.toStringAsFixed(2)} meters';
    } else {
      double kilometers = meters / 1000;
      return '${kilometers.toStringAsFixed(2)} km';
    }
  }
}
