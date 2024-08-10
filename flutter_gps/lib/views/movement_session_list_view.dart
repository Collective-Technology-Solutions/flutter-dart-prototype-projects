// lib/views/movement_session_list_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_gps/models/movement_session.dart';
import 'package:flutter_gps/sample_data/movement_session_support.dart';
import 'package:flutter_gps/utils/movement_support.dart';
import 'package:flutter_gps/views/app_settings.dart';
import 'package:provider/provider.dart';

class MovementSessionListView extends StatefulWidget {
  @override
  _MovementSessionListViewState createState() =>
      _MovementSessionListViewState();
}

class _MovementSessionListViewState extends State<MovementSessionListView> {
  late List<MovementSession> _sessions;

  @override
  void initState() {
    super.initState();
    // Initialize or fetch sessions
    _sessions = [
      createSampleSession(MovementType.walking),
      createSampleSession(MovementType.running),
      createSampleSession(MovementType.bicycling)
    ];
    // Generate metrics for each session
    // List<Map<String, dynamic>> metricsList = _sessions.map((session) {
    //   return generateMovementMetrics(session);
    // }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context).settings;
    bool useImperial = settings.useImperial;

    double baseFont = 14.0;
    TextStyle keyStyle = TextStyle(
      fontSize: baseFont,
      // color: Colors.blue,
      fontWeight: FontWeight.bold,
    );
    TextStyle valueStyle = TextStyle(
      fontSize: baseFont-1,
      // color: Colors.blue,
      // fontWeight: FontWeight.bold,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movement Sessions'),
      ),
      body: ListView(
        children: _sessions.map((session) {
          final metrics = generateMovementMetrics(session);
          return ExpansionTile(
            title: Text('Session ${session.name} (${metrics['totalDistance'].toStringAsFixed(2)})'),
            subtitle: Text('Movement Type: ${metrics['movementType'].toString()}'),
            children: _createListTitlesUI( metrics, keyStyle, valueStyle, useImperial),
          );
        }).toList(),
      ),
    );
  }

  List<_Pair<String,String>> _getUIListElements(Map<String, dynamic> metrics, bool useImperial) {
    final String caloriesBurnedRangeString =
        '${metrics['caloriesBurnedRange']['min'].toStringAsFixed(2)} - ${metrics['caloriesBurnedRange']['max'].toStringAsFixed(2)} kcal';
    return [
    _Pair('Average Accuracy (range)', '${convertDistance(metrics['averageAccuracy'], useImperial: useImperial)}'),
    _Pair('Min Speed','${convertDistance(metrics['minSpeed'], useImperial: useImperial)}/s'),
    _Pair('Max Speed', '${convertDistance(metrics['maxSpeed'], useImperial: useImperial)}/s'),
    _Pair('Average Speed', '${convertDistance(metrics['averageSpeed'], useImperial: useImperial)}/s'),
    _Pair('Total Distance', '${convertDistance(metrics['totalDistance'], useImperial: useImperial)}'),
    _Pair('Calories Burned (range)', '${caloriesBurnedRangeString}'),
    ];
  }

  List<Widget> _createListTitlesUI( Map<String, dynamic> metrics, TextStyle keyStyle, TextStyle valueStyle, bool useImperial) {
    return _getUIListElements(metrics, useImperial).map((e) => _createListTile(e.first, e.second, keyStyle, valueStyle)).toList();
  }

  ListTile _createListTile(
      String key, String value, TextStyle keyStyle, TextStyle valueStyle) {
    return ListTile(
      title: Text(key, style: keyStyle),
      subtitle: Text(value, style: valueStyle),
    );
  }
}

class _Pair<T, U> {
  final T first;
  final U second;

  _Pair(this.first, this.second);

  @override
  String toString() => 'Pair($first, $second)';
}