import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../block/empBlock.dart';
import '../database/databaseHelper.dart';
import '../model/empModel.dart';
import 'EmployeeListScreen.dart';

class AddEditEmployeeScreen extends StatefulWidget {
  final Employee? employee;
  final bool? check;

  AddEditEmployeeScreen({this.employee, this.check});

  @override
  _AddEditEmployeeScreenState createState() => _AddEditEmployeeScreenState();
}

class _AddEditEmployeeScreenState extends State<AddEditEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController positionController;
  late DateTime selectedDate;
  final DatabaseHelper databaseHelper = DatabaseHelper.instance;
  List<String> position = [
    "Product Designer",
    "Flutter Developer",
    "QA Tester",
    "Product Owner"
  ];
  DateTime? startDate, endDate;
  String? showStartDate, showEndDate;

  Future<void> selectStartDate() async {
    final DateTime? picked = await showDatePicker(
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        context: context,
        initialDate: startDate ?? DateTime.now(),
        firstDate: DateTime(200),
        lastDate: DateTime(2101));
    if (picked != null && picked != startDate) {
      setState(() {
        String formattedDate = DateFormat('d MMM yyyy').format(picked);
        print("formattedDate is:$formattedDate");
        startDate = picked;
        showStartDate = formattedDate;
      });
    }
  }

  Future<void> selectEndDate() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: endDate ?? DateTime.now(),
        firstDate: DateTime(200),
        lastDate: DateTime(2101));
    if (picked != null && picked != endDate) {
      setState(() {
        String formattedDate = DateFormat('d MMM yyyy').format(picked);
        print("formattedDate is:$formattedDate");
        endDate = picked;
        showEndDate = formattedDate;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(
        text: widget.employee == null ? "" : widget.employee!.name);
    positionController = TextEditingController(
        text: widget.employee == null ? "" : widget.employee!.position);
    showEndDate = widget.employee == null || widget.check == false
        ? "No date"
        : DateFormat('d MMM yyyy').format(widget.employee!.endDate!);
    showStartDate = widget.employee == null
        ? "No date"
        : DateFormat('d MMM yyyy').format(widget.employee!.startDate!);
    // Use the provided or current date.
  }

  showRolePicker() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        context: context,
        builder: (BuildContext context) {
          return Wrap(
            children: position.map(
              (e) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.grey, width: 1)),
                  ),
                  child: ListTile(
                    title: Center(child: Text(e)),
                    onTap: () {
                      setState(() {
                        positionController.text = e;
                      });
                      Navigator.pop(context);
                    },
                  ),
                );
              },
            ).toList(),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          title: Text(widget.employee == null
              ? 'Add Employee Details'
              : 'Edit Employee Details')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  hintText: "Employee name",
                  prefixIcon: Image.asset("assets/person.png"),
                  border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.grey.withOpacity(0.5))),
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.grey.withOpacity(0.5))),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.grey.withOpacity(0.5))),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                readOnly: true,
                controller: positionController,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey.withOpacity(0.5))),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey.withOpacity(0.5))),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey.withOpacity(0.5))),
                    hintText: "Select role",
                    prefixIcon: Image.asset("assets/role.png"),
                    suffixIcon: Icon(Icons.arrow_drop_down)),
                onTap: () {
                  showRolePicker();
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a position';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10,
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.white,
                      side: BorderSide(color: Colors.grey.withOpacity(0.5))),
                  onPressed: () {
                    selectStartDate();
                  },
                  icon: Image.asset("assets/calender.png"),
                  label: Text(
                    showStartDate ?? "No date",
                    style: TextStyle(
                        color:
                            showStartDate == null ? Colors.grey : Colors.black),
                  ),
                ),
                title: Icon(
                  Icons.arrow_forward,
                  color: Colors.blue,
                ),
                trailing: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.white,
                      side: BorderSide(color: Colors.grey.withOpacity(0.5))),
                  onPressed: () {
                    selectEndDate();
                  },
                  icon: Image.asset("assets/calender.png"),
                  label: Text(
                    showEndDate ?? "No date",
                    style: TextStyle(
                        color:
                            showEndDate == null ? Colors.grey : Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: 0, backgroundColor: Color(0xffEDF8FF)),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "cancle",
                style: TextStyle(color: Colors.blue),
              )),
          SizedBox(
            width: 10,
          ),
          ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Form is valid, save employee data to the database.
                  final newEmployee = Employee(
                      name: nameController.text,
                      position: positionController.text,
                      startDate: startDate ?? widget.employee!.startDate,
                      endDate: endDate ?? DateTime(200));
                  if (widget.employee == null) {
                    // Adding a new employee
                    databaseHelper.createEmployee(newEmployee);
                    BlocProvider.of<EmployeeBloc>(context)
                        .add(AddEmployee(newEmployee));
                    Navigator.pop(context);
                    /* Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => EmployeeListScreen(),
                    ));*/
                  } else {
                    // Editing an existing employee
                    newEmployee.id = widget.employee!.id;
                    databaseHelper.updateEmployee(newEmployee);
                    BlocProvider.of<EmployeeBloc>(context)
                        .add(UpdateEmployee(newEmployee));
                    Navigator.pop(context);
                  } // Return to the employee list screen.
                }
              },
              child: Text(
                "Save",
              )),
        ],
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    positionController.dispose();
    super.dispose();
  }
}
