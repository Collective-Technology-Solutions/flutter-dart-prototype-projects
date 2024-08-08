import 'package:flutter/material.dart';
import 'package:flutter_gps/views/app_settings.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Spinner control for update frequency
            Text('Positional Update Frequency (seconds)'),
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
            SizedBox(height: 16),

            // Toggle for precision
            Text('Precision'),
            SwitchListTile(
              title: Text('Fine Precision'),
              value: settingsProvider.settings.isFinePrecision,
              onChanged: (value) {
                settingsProvider.togglePrecision();
              },
            ),
            SizedBox(height: 16),


            // Spinner control for ignore radius
            Text('Ignore updates inside radius (meters)'),
            DropdownButton<int>(
              value: settingsProvider.settings.ignoreRadius,
              onChanged: (newValue) {
                settingsProvider.updateIgnoreRadius(newValue!);
              },
              items: List.generate(10, (index) => index + 1)
                  .map((value) => DropdownMenuItem<int>(
                value: value,
                child: Text(value.toString()),
              ))
                  .toList(),
            ),
            SizedBox(height: 16),

            // Toggle for zoom on accuracy
            SwitchListTile(
              title: Text('Zoom on Accuracy'),
              value: settingsProvider.settings.zoomOnAccuracy,
              onChanged: (value) {
                settingsProvider.toggleZoomOnAccuracy();
              },
            ),

            // Spinner control for update frequency
            Text('Cache Expiration (days)'),
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
            SizedBox(height: 16),

          ],
        ),
      ),
    );
  }
}
