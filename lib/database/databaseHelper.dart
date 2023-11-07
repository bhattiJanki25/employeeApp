import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../block/empBlock.dart';
import '../model/empModel.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'employee_database.db');

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE employees(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        position TEXT,
        startDate TEXT,
        endDate TEXT
      )
    ''');
  }

  Future<int> createEmployee(Employee employee) async {
    final db = await instance.database;
    final reponse = await db.insert('employees', employee.toMap());
    print("in createEmployee....***$reponse ");
    return reponse;
  }

  Future<int> updateEmployee(Employee employee) async {
    final db = await instance.database;
    final res = await db.update('employees', employee.toMap(),
        where: 'id = ?', whereArgs: [employee.id]);
    print("updateEmployee..................$res");
    return res;
  }

  Future<Map<String, dynamic>?> readEmployee(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'employees',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return maps.first;
    } else {
      return null;
    }
  }

  Future<List<Employee>> readAllEmployees() async {
    final db = await instance.database;
    final result = await db.query('employees');
    print("readAllEmployees is:$result");
    return result.map((map) => Employee.fromMap(map)).toList();
  }

/*  Future<int> updateEmployee(Map<String, dynamic> employee) async {
    final db = await instance.database;
    final id = employee['id'];
    return await db.update(
      'employees',
      employee,
      where: 'id = ?',
      whereArgs: [id],
    );
  }*/

  Future<int> deleteEmployee(int id) async {
    final db = await instance.database;
    return await db.delete(
      'employees',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
