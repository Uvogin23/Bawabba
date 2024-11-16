// ignore_for_file: unused_import

import 'package:flutter/material.dart';

class NonResident {
  final int id;
  final String firstName;
  final String lastName;
  final DateTime dateOfBirth;
  final String? placeOfBirth;
  final String passportNumber;
  final DateTime? passportExpiry;
  final String? nationality;
  final String? host;
  final String? purposeOfVisit;
  final DateTime arrivalDate;
  final DateTime? expectedDepartureDate;
  final String? vehicleInformation;
  final String? messageReference;
  final String? observations;
  final DateTime? createdAt;
  final String? msgRef;

  NonResident({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    this.placeOfBirth,
    required this.passportNumber,
    this.passportExpiry,
    this.nationality,
    this.host,
    this.purposeOfVisit,
    required this.arrivalDate,
    this.expectedDepartureDate,
    this.vehicleInformation,
    this.messageReference,
    this.observations,
    this.createdAt,
    this.msgRef,
  });

  factory NonResident.fromJson(Map<String, dynamic> json) {
    return NonResident(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      dateOfBirth: DateTime.parse(json['date_of_birth']),
      placeOfBirth: json['place_of_birth'],
      passportNumber: json['passport_number'],
      passportExpiry: json['passport_expiry'] != null
          ? DateTime.parse(json['passport_expiry'])
          : null,
      nationality: json['nationality'],
      host: json['host'],
      purposeOfVisit: json['purpose_of_visit'],
      arrivalDate: DateTime.parse(json['arrival_date']),
      expectedDepartureDate: json['expected_departure_date'] != null
          ? DateTime.parse(json['expected_departure_date'])
          : null,
      vehicleInformation: json['vehicle_information'],
      messageReference: json['message_reference'],
      observations: json['observations'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      msgRef: json['msg_ref'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'date_of_birth': dateOfBirth.toIso8601String(),
      'place_of_birth': placeOfBirth,
      'passport_number': passportNumber,
      'passport_expiry': passportExpiry?.toIso8601String(),
      'nationality': nationality,
      'host': host,
      'purpose_of_visit': purposeOfVisit,
      'arrival_date': arrivalDate.toIso8601String(),
      'expected_departure_date': expectedDepartureDate?.toIso8601String(),
      'vehicle_information': vehicleInformation,
      'message_reference': messageReference,
      'observations': observations,
      'created_at': createdAt?.toIso8601String(),
      'msg_ref': msgRef,
    };
  }
}
