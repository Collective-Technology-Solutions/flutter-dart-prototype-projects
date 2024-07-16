import 'dart:convert';  // For JSON encoding and decoding
import 'dart:io';       // For handling IO exceptions
import 'package:http/http.dart' as http;  // Import the http package
import 'dart:async';    // For handling delays
import 'package:logging/logging.dart';    // Import the logging package

void main() async {
  // Initialize logging
  _setupLogging();

  final logger = Logger('HTTPLogger');

  // Define the URL
  final url = Uri.parse('https://dummy.restapiexample.com/api/v1/employees');
  
  // Define the maximum number of retries and the delay between retries
  const int maxRetries = 3;
  const Duration delayBetweenRetries = Duration(seconds: 2);

  int attempt = 0;

  while (attempt < maxRetries) {
    try {
      // Increment the attempt counter
      attempt++;
      logger.info('Attempt $attempt');

      // Send an HTTP GET request
      final response = await http.get(url);

      // Check if the request was successful
      if (response.statusCode == 200) {
        // Parse the JSON response
        final data = jsonDecode(response.body);

        // Pretty print the JSON data
        final prettyString = const JsonEncoder.withIndent('  ').convert(data);
        logger.info('Response data: \n$prettyString');
        break; // Exit the loop if the request was successful
      } else {
        // Handle server errors
        logger.warning('Server error: ${response.statusCode}. ${response.reasonPhrase}');
      }
    } on SocketException {
      // Handle network errors
      logger.severe('Network error: Failed to connect to the server.');
    } on FormatException {
      // Handle JSON format errors
      logger.severe('Format error: Failed to decode the JSON response.');
    } on HttpException {
      // Handle HTTP-specific errors
      logger.severe('HTTP error: An HTTP error occurred.');
    } catch (e) {
      // Handle any other exceptions
      logger.severe('Unexpected error: $e');
    }

    if (attempt < maxRetries) {
      logger.info('Retrying in ${delayBetweenRetries.inSeconds} seconds...');
      await Future.delayed(delayBetweenRetries); // Wait before retrying
    } else {
      logger.severe('Max retries reached. Exiting.');
    }
  }
}

void _setupLogging() {
  // Configure the logging system
  Logger.root.level = Level.ALL;  // Set the root logger level
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.loggerName}: ${rec.message}');
  });
}

