// ignore_for_file: unused_import

import 'package:flutter/material.dart';

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

  factory DiplomatAccompaniment.fromJson(Map<String, dynamic> json) {
    return DiplomatAccompaniment(
      id: json['id'],
      diplomatId: json['diplomat_id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      relationship: json['relationship'],
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.parse(json['date_of_birth'])
          : null,
      passportNumber: json['passport_number'],
      passportExpiry: json['passport_expiry'] != null
          ? DateTime.parse(json['passport_expiry'])
          : null,
      nationality: json['nationality'],
      arrivalDate: json['arrival_date'] != null
          ? DateTime.parse(json['arrival_date'])
          : null,
      expectedDepartureDate: json['expected_departure_date'] != null
          ? DateTime.parse(json['expected_departure_date'])
          : null,
      touristicGuide: json['touristic_guide'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
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
