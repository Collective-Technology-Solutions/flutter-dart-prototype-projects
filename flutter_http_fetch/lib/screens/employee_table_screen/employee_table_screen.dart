import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:io';

import '../../models/employee.dart';
import '../edit_employee_screen/edit_employee_screen.dart';
import 'employee_table.dart';

class EmployeeTableScreen extends StatefulWidget {
  final Uri uri;

  const EmployeeTableScreen({super.key, required this.uri});

  @override
  _EmployeeTableScreenState createState() => _EmployeeTableScreenState();
  //TODO: evaluate this statement: State<EmployeeTableScreen> createState() => _EmployeeTableScreenState();
}

class _EmployeeTableScreenState extends State<EmployeeTableScreen> {
  final Logger logger = Logger('HTTPLogger');
  List<Employee> employees = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchEmployees(widget.uri);
  }

  Future<void> _fetchEmployees(Uri uri) async {
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
          setState(() {
            employees = (data['data'] as List).map((json) => Employee.fromJson(json)).toList();
            isLoading = false;
          });
          var message = 'Data fetched successfully';
          logger.info(message);
          _showSnackbar(message);
          break;
        } else {
          logger.warning('Server error: ${response.statusCode}. ${response.reasonPhrase}');
          if ( response.statusCode == 429 ) {
            int interval = 35 * (attempt+1);
            var duration = Duration(seconds: interval);
            var message = 'Backing off data request. Waiting $duration...';
            logger.info(message);
            _showSnackbar( message );
            await Future.delayed(duration);
          }
        }
      } on SocketException {
        var message = 'Network error: Failed to connect to the server.';
        logger.severe(message);
        _showSnackbar(message);
      } on FormatException {
        var message = 'Format error: Failed to decode the JSON response.';
        logger.severe(message);
        _showSnackbar(message);
      } on HttpException {
        var message = 'HTTP error: An HTTP error occurred.';
        logger.severe(message);
        _showSnackbar(message);
      } catch (e) {
        var message = 'Unexpected error: $e';
        logger.severe(message);
        _showSnackbar(message);
      }

      if (attempt < maxRetries) {
        logger.info('Retrying in ${delayBetweenRetries.inSeconds} seconds...');
        await Future.delayed(delayBetweenRetries);
      } else {
        var message = 'Max retries reached. Exiting.';
        logger.severe(message);
        _showSnackbar(message);
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _showSnackbar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _editEmployee(Employee employee) async {
    final updatedEmployee = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditEmployeeScreen(employee: employee)),
    );

    //TODO: fix but later
    // if (updatedEmployee != null) {
    //   setState(() {
    //     employees = employees.map((e) => e.id == updatedEmployee.id ? updatedEmployee : e).toList<>();
    //   });
    //  }
    // TODO: remove below code block once lambda above is corrected
      final index = employees.indexWhere((e) => e.id == updatedEmployee.id);
      if (index != -1) {
        setState(() {
          employees[index] = updatedEmployee;
        });
      }
  }
/*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee Table'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: EmployeeTable(
                employees: employees,
                onEdit: _editEmployee,
              ),
            ),
    );
  } */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Table'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: EmployeeTable(
            employees: employees,
            onEdit: _editEmployee,
          ),
        ),
      ),
    );
  }
}

