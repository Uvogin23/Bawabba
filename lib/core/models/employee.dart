import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Employee {
  final int id;
  final String username;
  final String role;
  final int employeeId;
  final String firstName;
  final String lastName;
  final String grade;
  final String badgeNumber;

  Employee(
      {required this.id,
      required this.username,
      required this.role,
      required this.employeeId,
      required this.firstName,
      required this.lastName,
      required this.grade,
      required this.badgeNumber});

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
        id: json['user_id'],
        username: json['username'],
        role: json['role'],
        employeeId: json['employee_id'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        grade: json['grade'],
        badgeNumber: json['badge_number']);
  }
}
