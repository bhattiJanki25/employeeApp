import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../block/empBlock.dart';
import '../database/databaseHelper.dart';
import '../main.dart';
import '../model/empModel.dart';

class EditEmployeeScreen extends StatefulWidget {
  final Employee employee;

  EditEmployeeScreen(this.employee);

  @override
  _EditEmployeeScreenState createState() => _EditEmployeeScreenState();
}

class _EditEmployeeScreenState extends State<EditEmployeeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Employee')),
      body: YourEditEmployeeFormWidget(widget.employee),
    );
  }
}

class YourEditEmployeeFormWidget extends StatefulWidget {
  final Employee employee;

  YourEditEmployeeFormWidget(this.employee);

  @override
  _YourEditEmployeeFormWidgetState createState() =>
      _YourEditEmployeeFormWidgetState();
}

class _YourEditEmployeeFormWidgetState
    extends State<YourEditEmployeeFormWidget> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  late DateTime selectedDate;
  final DatabaseHelper databaseHelper = DatabaseHelper.instance;
  @override
  void initState() {
    super.initState();
    // Initialize the text fields with the employee's current data
    nameController.text = widget.employee.name;
    positionController.text = widget.employee.position;
    selectedDate = widget.employee?.startDate ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: positionController,
            decoration: InputDecoration(labelText: 'Position'),
          ),
          ListTile(
            title: Text(
              'Date of Birth: ${selectedDate.toLocal()}'.split(' ')[0],
            ),
            trailing: Icon(Icons.calendar_today),
            onTap: () async {
              final newDate = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime(1900),
                lastDate: DateTime(2101),
              );
              if (newDate != null) {
                setState(() {
                  selectedDate = newDate;
                  print("selectedDate is,,,,$selectedDate");
                });
              }
            },
          ),
          ElevatedButton(
            onPressed: () {
              // Update the employee data and save it to the database
              final updatedEmployee = Employee(
                name: nameController.text,
                position: positionController.text,
                startDate: selectedDate,
              );
              updatedEmployee.id = widget.employee!.id;
              databaseHelper.updateEmployee(updatedEmployee);
              // Dispatch the UpdateEmployee event to your BLoC
              BlocProvider.of<EmployeeBloc>(context)
                  .add(UpdateEmployee(updatedEmployee));

              // Navigate back to the employee list screen
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text('Save Changes'),
          ),
        ],
      ),
    );
  }
}
