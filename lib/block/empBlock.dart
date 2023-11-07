/*
import 'package:flutter_bloc/flutter_bloc.dart';

import '../database/databaseHelper.dart';
import '../model/empModel.dart';

// EmployeeBloc Events
abstract class EmployeeEvent {}

class FetchEmployees extends EmployeeEvent {}

class AddEmployee extends EmployeeEvent {
  final Employee employee;

  AddEmployee(this.employee);
}

class UpdateEmployee extends EmployeeEvent {
  final Employee employee;

  UpdateEmployee(this.employee);
}

class DeleteEmployee extends EmployeeEvent {
  final int employeeId;

  DeleteEmployee(this.employeeId);
}

// EmployeeBloc State
class EmployeeState {
  final List<Employee> employees;

  EmployeeState(this.employees);
}

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  EmployeeBloc() : super(EmployeeState([]));
  final DatabaseHelper databaseHelper = DatabaseHelper.instance;

  @override
  Stream<EmployeeState> mapEventToState(EmployeeEvent event) async* {
    if (event is FetchEmployees) {
      final employees = await databaseHelper.readAllEmployees();
      yield EmployeeState(employees);
    } else if (event is AddEmployee) {
      await databaseHelper.createEmployee(event.employee);
      yield EmployeeState([...state.employees, event.employee]);
    } else if (event is UpdateEmployee) {
      await databaseHelper.updateEmployee(event.employee);
      final updatedEmployees = state.employees.map((employee) {
        return employee.id == event.employee.id ? event.employee : employee;
      }).toList();
      yield EmployeeState(updatedEmployees);
    } else if (event is DeleteEmployee) {
      await databaseHelper.deleteEmployee(event.employeeId);
      final remainingEmployees = state.employees
          .where((employee) => employee.id != event.employeeId)
          .toList();
      yield EmployeeState(remainingEmployees);
    }
  }
}
*/

import 'package:flutter_bloc/flutter_bloc.dart';

import '../database/databaseHelper.dart';
import '../model/empModel.dart';

// Define the states for the EmployeeBloc
abstract class EmployeeState {}

class EmployeeLoadInProgress extends EmployeeState {}

class EmployeeLoadSuccess extends EmployeeState {
  final List<Employee> employees;

  EmployeeLoadSuccess(this.employees);
}

class EmployeeLoadFailure extends EmployeeState {
  final String error;

  EmployeeLoadFailure(this.error);
}

// Define the events for the EmployeeBloc
abstract class EmployeeEvent {}

class FetchEmployees extends EmployeeEvent {}

class AddEmployee extends EmployeeEvent {
  final Employee employee;

  AddEmployee(this.employee);
}

class UpdateEmployee extends EmployeeEvent {
  final Employee employee;

  UpdateEmployee(this.employee);
}

class DeleteEmployee extends EmployeeEvent {
  final String employeeName;

  DeleteEmployee(this.employeeName);
}

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  EmployeeBloc() : super(EmployeeLoadInProgress());
  final DatabaseHelper databaseHelper = DatabaseHelper.instance;
  @override
  Stream<EmployeeState> mapEventToState(EmployeeEvent event) async* {
    if (event is FetchEmployees) {
      final employees = await databaseHelper.readAllEmployees();
      yield EmployeeLoadSuccess(employees);
    } else if (event is AddEmployee) {
      // Retrieve the current state to access the list of employees
      final currentState = state;
      if (currentState is EmployeeLoadSuccess) {
        // Create a copy of the current list and add the new employee
        final List<Employee> updatedEmployees =
            List.from(currentState.employees);
        updatedEmployees.add(event.employee);

        // Yield the updated state with the new list of employees
        yield EmployeeLoadSuccess(updatedEmployees);
      }
    } else if (event is UpdateEmployee) {
      // Retrieve the current state to access the list of employees
      final currentState = state;
      if (currentState is EmployeeLoadSuccess) {
        // Create a copy of the current list and find the index of the employee to update
        final List<Employee> updatedEmployees =
            List.from(currentState.employees);
        final int indexOfEmployee =
            updatedEmployees.indexWhere((e) => e.name == event.employee.name);

        if (indexOfEmployee >= 0) {
          // Update the employee data
          updatedEmployees[indexOfEmployee] = event.employee;
          // Yield the updated state with the new list of employees
          yield EmployeeLoadSuccess(updatedEmployees);
        }
      }
    } else if (event is DeleteEmployee) {
      // Retrieve the current state to access the list of employees
      final currentState = state;
      if (currentState is EmployeeLoadSuccess) {
        // Create a copy of the current list and find the index of the employee to delete
        final List<Employee> updatedEmployees =
            List.from(currentState.employees);
        final int indexOfEmployee =
            updatedEmployees.indexWhere((e) => e.name == event.employeeName);

        if (indexOfEmployee >= 0) {
          // Remove the employee from the list
          updatedEmployees.removeAt(indexOfEmployee);

          // Yield the updated state with the new list of employees
          yield EmployeeLoadSuccess(updatedEmployees);
        }
      }
    }
  }
}
