import 'package:flutter/material.dart';
import '../../models/employee.dart';

class EmployeeTable extends StatelessWidget {
  final List<Employee> employees;
  final Function(Employee) onEdit;

  const EmployeeTable({super.key, required this.employees, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: const [
        DataColumn(label: Text('ID')),
        DataColumn(label: Text('Name')),
        DataColumn(label: Text('Salary')),
        DataColumn(label: Text('Age')),
      ],
      rows: employees.map((employee) {
        return DataRow(
          cells: [
            DataCell(Text(employee.id.toString())),
            DataCell(Text(employee.name)),
            DataCell(Text(employee.salary.toString())),
            DataCell(Text(employee.age.toString())),
          ],
          onSelectChanged: (_) {
            onEdit(employee);
          },
        );
      }).toList(),
    );
  }
}

