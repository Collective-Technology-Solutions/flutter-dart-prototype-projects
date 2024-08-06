import 'package:flutter/foundation.dart';

class Logger {
  static void initialize() {
    // Initialization code for logging, if needed
  }

  static void log(String message) {
    if (kDebugMode) {
      print("[LOG] $message");
    }
  }
}
