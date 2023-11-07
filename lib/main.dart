import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Screens/AddEditEmpScreen.dart';
import 'Screens/EmployeeListScreen.dart';
import 'block/empBlock.dart';

void main() {
  runApp(BlocProvider(
      create: (context) => EmployeeBloc(), // Create your EmployeeBloc instance
      child: MaterialApp(
        routes: {
          '/AddEditEmployee': (context) => AddEditEmployeeScreen(),
        },
        theme: ThemeData(
          fontFamily: 'Roboto_Family',
        ),
        debugShowCheckedModeBanner: false,
        home: EmployeeListScreen(),
      )));
}
