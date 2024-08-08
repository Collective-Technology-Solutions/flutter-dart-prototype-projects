import 'package:flutter/material.dart';
import 'package:flutter_gps/views/app_settings.dart';
import 'my_home_page.dart';
import 'package:provider/provider.dart';

void main() {
  // runApp(const MyApp());
  runApp(
    ChangeNotifierProvider(
      create: (context) => SettingsProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GPS Positioning',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}


