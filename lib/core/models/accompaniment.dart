// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DiplomatAccompaniment {
  final int id;
  final int diplomatId;
  final String firstName;
  final String lastName;
  final String? relationship;
  final DateTime? dateOfBirth;
  final String? passportNumber;
  final DateTime? passportExpiry;
  final String? nationality;
  final DateTime? arrivalDate;
  final DateTime? expectedDepartureDate;
  final String? touristicGuide;
  final DateTime? createdAt;

  DiplomatAccompaniment({
    required this.id,
    required this.diplomatId,
    required this.firstName,
    required this.lastName,
    this.relationship,
    this.dateOfBirth,
    this.passportNumber,
    this.passportExpiry,
    this.nationality,
    this.arrivalDate,
    this.expectedDepartureDate,
    this.touristicGuide,
    this.createdAt,
  });

  factory DiplomatAccompaniment.fromJson(List<dynamic> json) {
    final rfc1123Format = DateFormat('EEE, dd MMM yyyy HH:mm:ss \'GMT\'');
    return DiplomatAccompaniment(
      id: json[0],
      diplomatId: json[1],
      firstName: json[2],
      lastName: json[3],
      relationship: json[4],
      dateOfBirth: json[5] != null ? rfc1123Format.parse(json[5]) : null,
      passportNumber: json[6],
      passportExpiry: json[7] != null ? rfc1123Format.parse(json[7]) : null,
      nationality: json[8],
      arrivalDate: json[9] != null ? rfc1123Format.parse(json[9]) : null,
      expectedDepartureDate:
          json[10] != null ? rfc1123Format.parse(json[10]) : null,
      touristicGuide: json[11],
      createdAt: json[12] != null ? rfc1123Format.parse(json[12]) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'diplomat_id': diplomatId,
      'first_name': firstName,
      'last_name': lastName,
      'relationship': relationship,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'passport_number': passportNumber,
      'passport_expiry': passportExpiry?.toIso8601String(),
      'nationality': nationality,
      'arrival_date': arrivalDate?.toIso8601String(),
      'expected_departure_date': expectedDepartureDate?.toIso8601String(),
      'touristic_guide': touristicGuide,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
