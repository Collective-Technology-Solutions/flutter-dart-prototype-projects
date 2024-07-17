import 'package:flutter/material.dart';
import '../../models/employee.dart';

class EditEmployeeScreen extends StatefulWidget {
  final Employee employee;

  const EditEmployeeScreen({super.key, required this.employee});

  @override
  _EditEmployeeScreenState createState() => _EditEmployeeScreenState();
  //TODO: evaluate this statement: State<EditEmployeeScreen> createState() => _EditEmployeeScreenState();
}

class _EditEmployeeScreenState extends State<EditEmployeeScreen> {
  late TextEditingController _nameController;
  late TextEditingController _salaryController;
  late TextEditingController _ageController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.employee.name);
    _salaryController = TextEditingController(text: widget.employee.salary.toString());
    _ageController = TextEditingController(text: widget.employee.age.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _salaryController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _save() {
    final updatedEmployee = Employee(
      id: widget.employee.id,
      name: _nameController.text,
      salary: double.parse(_salaryController.text),
      age: int.parse(_ageController.text),
    );

    Navigator.pop(context, updatedEmployee);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Employee'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _salaryController,
              decoration: const InputDecoration(labelText: 'Salary'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _ageController,
              decoration: const InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _save,
                  child: const Text('Save'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

