class Employee {
  int? id;
  String name;
  String position;
  DateTime startDate;
  DateTime? endDate;

  Employee(
      {this.id,
      required this.name,
      required this.position,
      required this.startDate,
      this.endDate});

  // Define a factory constructor to create an Employee object from a map.
  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      id: map['id'],
      name: map['name'],
      position: map['position'],
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
    );
  }

  // Define a method to convert the Employee object to a map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'position': position,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate == null ? "" : endDate!.toIso8601String(),
    };
  }
}
