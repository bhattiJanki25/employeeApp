import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../block/empBlock.dart';
import '../database/databaseHelper.dart';
import '../model/empModel.dart';
import 'AddEditEmpScreen.dart';

class EmployeeListScreen extends StatefulWidget {
  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  final DatabaseHelper databaseHelper = DatabaseHelper.instance;
  List<Employee> empList = [];
  @override
  void initState() {
    context.read<EmployeeBloc>().add(FetchEmployees());
    super.initState();
  }

  Widget _buildEmployeeList(
      String title, List<Employee> employees, bool check) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          tileColor: Colors.grey.withOpacity(0.2),
          title: Text(
            title,
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: employees.length,
          itemBuilder: (context, index) {
            String StartDate1 =
                DateFormat('d MMM yyyy').format(employees[index].startDate);
            return Dismissible(
                key: Key(UniqueKey().toString()),
                direction: DismissDirection.horizontal,
                onDismissed: (direction) {
                  empList = employees;
                  databaseHelper.deleteEmployee(employees[index].id!);
                  // Dispatch the UpdateEmployee event to your BLoC
                  BlocProvider.of<EmployeeBloc>(context)
                      .add(DeleteEmployee(employees[index].name));
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Employee data has been deleted")));
                },
                background: Container(
                    alignment: AlignmentDirectional.centerEnd,
                    color: Colors.red,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                            padding: EdgeInsets.fromLTRB(0.0, 0.0,
                                MediaQuery.of(context).size.width * 0.02, 0.0),
                            child: Image.asset("assets/delete.png")),
                      ],
                    )),
                child: ListTile(
                  title: Text(
                    employees[index].name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: check
                      ? Text(
                          "${employees[index].position} \n${DateFormat('d MMM yyyy').format(employees[index].startDate)} - ${DateFormat('d MMM yyyy').format(employees[index].endDate!)}")
                      : Text("${employees[index].position} \nFrom $StartDate1"),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AddEditEmployeeScreen(
                        employee: employees[index],
                        check: check,
                      ),
                    ));
                  },
                ));
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    context.read<EmployeeBloc>().add(FetchEmployees());
    return BlocBuilder<EmployeeBloc, EmployeeState>(
      bloc: context.read<EmployeeBloc>(),
      builder: (context, state) {
        if (state is EmployeeLoadSuccess) {
          empList = state.employees;

          final currentEmployees = state.employees
              .where((employee) => employee.endDate == DateTime(200))
              .toList();

          final previousEmployees = state.employees
              .where((employee) => employee.endDate != DateTime(200))
              .toList();
          return Scaffold(
              floatingActionButtonLocation: state.employees.isNotEmpty
                  ? FloatingActionButtonLocation.centerDocked
                  : FloatingActionButtonLocation.endDocked,
              bottomSheet: state.employees.isNotEmpty
                  ? Container(
                      color: Colors.grey.withOpacity(0.2),
                      height: MediaQuery.of(context).size.height * .07,
                      padding: EdgeInsets.only(left: 20, right: 20, top: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Swipe left to delete",
                            style: TextStyle(color: Colors.black54),
                          ),
                          FloatingActionButton(
                            mini: true,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            heroTag: "tag1",
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => AddEditEmployeeScreen(),
                              ));
                            },
                            child: Icon(Icons.add),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      height: 70,
                      alignment: Alignment.bottomRight,
                      child: FloatingActionButton(
                        mini: true,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        heroTag: "tag1",
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AddEditEmployeeScreen(),
                          ));
                        },
                        child: Icon(Icons.add),
                      ),
                    ),
              appBar: AppBar(
                title: Text('Employee List'),
              ),
              body: state.employees.isNotEmpty
                  ? SingleChildScrollView(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildEmployeeList(
                                'Current Employees', currentEmployees, false),
                            _buildEmployeeList(
                                'Previous Employees', previousEmployees, true),
                          ],
                        ),
                      ),
                    )
                  : Center(
                      child: Image.asset("assets/nodataBg.png"),
                    ));
        } else if (state is EmployeeLoadInProgress) {
          return Center(child: CircularProgressIndicator());
        } else if (state is EmployeeLoadFailure) {
          return Center(child: Text('Error: ${state.error}'));
        } else {
          return Center(child: Text('Unknown state'));
        }
      },
    );
  }
}
