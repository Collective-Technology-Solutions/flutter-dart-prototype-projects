import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'screens/employee_table_screen/employee_table_screen.dart';

void main() {
  _configureLogging();
  runApp(const MyApp());
}

void _configureLogging() {
  Logger.root.level = Level.ALL; // Set the logging level to ALL
  Logger.root.onRecord.listen((LogRecord record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Employee Table',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: EmployeeTableScreen(uri: Uri.parse('https://dummy.restapiexample.com/api/v1/employees')),
    );
  }
}

