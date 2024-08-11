import 'package:flutter/material.dart';
import 'package:flutter_gps/utils/map_support.dart';
import 'package:flutter_gps/providers/app_settings.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  // if used here, we are no longer stateless
  // final Logger _logger = Logger('SettingsScreen');

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);  // to send update notifications via methods
    final settings = settingsProvider.settings; // for read only
    
    double fieldPadding = 1;
    double baseFont = 14.0;

    TextStyle groupTextStyle = TextStyle(
      fontSize: baseFont + 6,
      // color: Colors.blue,
      fontWeight: FontWeight.bold,
    );
    TextStyle toggleTextStyle = TextStyle(
      fontSize: baseFont,
      // color: Colors.blue,
      // fontWeight: FontWeight.bold,
    );
    TextStyle fieldTextStyle = TextStyle(
      fontSize: baseFont,
      // color: Colors.blue,
      // fontWeight: FontWeight.bold,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Data', style: groupTextStyle),

            // Toggle for precision
            DropdownButton<LocationAccuracy>(
              value: settings.locationAccuracy,
              onChanged: (LocationAccuracy? newValue) {
                settingsProvider.updateLocationAccuracy(newValue!);
              },
              items: LocationAccuracy.values.map((LocationAccuracy accuracy) {
                return DropdownMenuItem<LocationAccuracy>(
                  value: accuracy,
                  child: Text(accuracy.toString()),
                );
              }).toList(),
            ),
            SizedBox(height: fieldPadding),

            // Spinner control for update frequency
            Text(
              'Data Cache Expiration (days)',
              style: fieldTextStyle,
            ),
            DropdownButton<int>(
              value: settings.cacheExpirationDays,
              onChanged: (newValue) {
                settingsProvider.updateCacheExpirationDays(newValue!);
              },
              items: List.generate(30, (index) => index + 1)
                  .map((value) => DropdownMenuItem<int>(
                        value: value,
                        child: Text(value.toString()),
                      ))
                  .toList(),
            ),
            SizedBox(height: fieldPadding),

            // Spinner control for cache item max count
            Text(
              'Data Cache Max Count',
              style: fieldTextStyle,
            ),
            DropdownButton<int>(
              value: settings.cacheExpirationMaxCount,
              onChanged: (newValue) {
                settingsProvider.updateCacheExpirationMaxCount(newValue!);
              },
              items: List.generate(10, (index) => index * 100)
                  .map((value) => DropdownMenuItem<int>(
                        value: value,
                        child: Text(value.toString()),
                      ))
                  .toList(),
            ),

            Text(
              'UI',
              style: groupTextStyle,
            ),

            SwitchListTile(
              title: Text(
                'Use Imperial Measurements',
                style: toggleTextStyle,
              ),
              value: settings.useImperial,
              // contentPadding: EdgeInsets.symmetric(horizontal: 0.0), // Adjust horizontal padding
              onChanged: (value) {
                settingsProvider.useImperial(value);
              },
            ),
            SizedBox(height: fieldPadding),

            // Spinner control for update frequency
            Text(
              'Update Data Frequency (seconds)',
              style: fieldTextStyle,
            ),
            DropdownButton<int>(
              value: settings.updateFrequencySeconds,
              onChanged: (newValue) {
                settingsProvider.updateFrequencySeconds(newValue!);
              },
              items: List.generate(120, (index) => index + 1)
                  .map((value) => DropdownMenuItem<int>(
                        value: value,
                        child: Text(value.toString()),
                      ))
                  .toList(),
            ),
            SizedBox(height: fieldPadding),

            // Spinner control for ignore radius
            Text(
              'Ignore Data Updates Within Radius (meters)',
              style: fieldTextStyle,
            ),
            DropdownButton<double>(
              value: settings.ignoreRadius,
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
            SizedBox(height: fieldPadding),

            // Toggle for precision
            SwitchListTile(
              title: Text(
                'Surpess Duplicates UI Updates',
                style: toggleTextStyle,
              ),
              value: settings.uiIgnoreDeplicatesOnLastUpdate,
              onChanged: (value) {
                settingsProvider.toggleUIIgnoreDeplicatesOnLastUpdate();
              },
            ),
            SizedBox(height: fieldPadding),

            // Spinner control for update frequency
            Text(
              'Max Data Tracked',
              style: fieldTextStyle,
            ),
            DropdownButton<int>(
              value: settings.uiMaxDataEntryCount,
              onChanged: (newValue) {
                settingsProvider.updateUIMaxDataEntryCount(newValue!);
              },
              items: List.generate(100, (index) => index * 10)
                  .map((value) => DropdownMenuItem<int>(
                        value: value,
                        child: Text(value.toString()),
                      ))
                  .toList(),
            ),
            SizedBox(height: fieldPadding),

            // Toggle for zoom on accuracy
            SwitchListTile(
              title: Text(
                'Update Zoom on Accuracy',
                style: toggleTextStyle,
              ),
              value: settings.zoomOnAccuracy,
              onChanged: (value) {
                settingsProvider.toggleZoomOnAccuracy();
              },
            ),
            SizedBox(height: fieldPadding),
          ],
        ),
      ),
    );
  }
}
