import 'package:flutter/material.dart';
import 'package:flutter_gps/views/app_settings.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  // if used here, we are no longer stateless
  // final Logger _logger = Logger('SettingsScreen');

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Toggle for zoom on accuracy
            SwitchListTile(
              title: const Text('Update Zoom on Accuracy'),
              value: settingsProvider.settings.zoomOnAccuracy,
              onChanged: (value) {
                settingsProvider.toggleZoomOnAccuracy();
              },
            ),
            const SizedBox(height: 16),

            // Spinner control for update frequency
            const Text('Update Data Frequency (seconds)'),
            DropdownButton<int>(
              value: settingsProvider.settings.updateFrequency,
              onChanged: (newValue) {
                settingsProvider.updateFrequency(newValue!);
              },
              items: List.generate(120, (index) => index + 1)
                  .map((value) => DropdownMenuItem<int>(
                value: value,
                child: Text(value.toString()),
              ))
                  .toList(),
            ),
            const SizedBox(height: 16),

            // Spinner control for update frequency
            const Text('Max Data Tracked'),
            DropdownButton<int>(
              value: settingsProvider.settings.maxDataEntryCount,
              onChanged: (newValue) {
                settingsProvider.updateFrequency(newValue!);
              },
              items: List.generate(100, (index) => index * 10)
                  .map((value) => DropdownMenuItem<int>(
                value: value,
                child: Text(value.toString()),
              ))
                  .toList(),
            ),
            const SizedBox(height: 16),

            // Toggle for precision
            const Text('Data Precision'),
            SwitchListTile(
              title: const Text('Fine Precision'),
              value: settingsProvider.settings.isFinePrecision,
              onChanged: (value) {
                settingsProvider.togglePrecision();
              },
            ),
            const SizedBox(height: 16),

            // Toggle for precision
            const Text('Sequential UI Duplicates'),
            SwitchListTile(
              title: const Text('Ignore Duplicates UI Updates'),
              value: settingsProvider.settings.uiDeduplicateOnLastUpdate,
              onChanged: (value) {
                settingsProvider.toggleDeduplicateOnLastUpdate();
              },
            ),
            const SizedBox(height: 16),

            // Spinner control for ignore radius
            const Text('Ignore Data Updates Within Radius (meters)'),
            DropdownButton<double>(
              value: settingsProvider.settings.ignoreRadius,
              onChanged: (newValue) {
                settingsProvider.updateIgnoreRadius(newValue!);
              },
              items: List.generate(11, (index) => index)
                  .map((value) => DropdownMenuItem<double>(
                value: value.toDouble(),
                child: Text(value.toString()),
              ))
                  .toList(),
            ),
            const SizedBox(height: 16),

            // Spinner control for update frequency
            const Text('Data Cache Expiration (days)'),
            DropdownButton<int>(
              value: settingsProvider.settings.cacheExpirationDays,
              onChanged: (newValue) {
                settingsProvider.cacheExpiration(newValue!);
              },
              items: List.generate(30, (index) => index + 1)
                  .map((value) => DropdownMenuItem<int>(
                value: value,
                child: Text(value.toString()),
              ))
                  .toList(),
            ),
            const SizedBox(height: 16),

            // Spinner control for cache item max count
            const Text('Data Cache Max Items'),
            DropdownButton<int>(
              value: settingsProvider.settings.maxNrOfCacheObjects,
              onChanged: (newValue) {
                settingsProvider.cacheExpiration(newValue!);
              },
              items: List.generate(10, (index) => index * 100)
                  .map((value) => DropdownMenuItem<int>(
                value: value,
                child: Text(value.toString()),
              ))
                  .toList(),
            ),

          ],
        ),
      ),
    );
  }
}
