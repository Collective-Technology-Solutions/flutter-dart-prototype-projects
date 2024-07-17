import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:logging/logging.dart';
import '../models/employee.dart';

class EmployeeService {
  final Logger logger = Logger('EmployeeService');
  final Uri uri;

  EmployeeService({required this.uri});

  Future<List<Employee>> fetchEmployees() async {
    const int maxRetries = 3;
    const Duration delayBetweenRetries = Duration(seconds: 2);
    int attempt = 0;

    while (attempt < maxRetries) {
      try {
        attempt++;
        logger.info('Attempt $attempt');

        final response = await http.get(uri);

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          return (data['data'] as List).map((json) => Employee.fromJson(json)).toList();
        } else {
          logger.warning('Server error: ${response.statusCode}. ${response.reasonPhrase}');
        }
      } on SocketException {
        logger.severe('Network error: Failed to connect to the server.');
      } on FormatException {
        logger.severe('Format error: Failed to decode the JSON response.');
      } on HttpException {
        logger.severe('HTTP error: An HTTP error occurred.');
      } catch (e) {
        logger.severe('Unexpected error: $e');
      }

      if (attempt < maxRetries) {
        logger.info('Retrying in ${delayBetweenRetries.inSeconds} seconds...');
        await Future.delayed(delayBetweenRetries);
      } else {
        logger.severe('Max retries reached. Exiting.');
        throw Exception('Failed to fetch employees after $maxRetries attempts');
      }
    }

    return [];
  }
}
 
