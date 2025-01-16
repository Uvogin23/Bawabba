// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NonResident {
  final int id;
  final String firstName;
  final String lastName;
  final DateTime dateOfBirth;
  final String placeOfBirth;
  final String passportNumber;
  final DateTime passportExpiry;
  final String nationality;
  final String host;
  final String purposeOfVisit;
  final DateTime arrivalDate;
  final DateTime expectedDepartureDate;
  final String vehicleInformation;
  final String observations;
  final DateTime createdAt;
  final String msgRef;
  final String? depMsgReff;

  NonResident(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.dateOfBirth,
      required this.placeOfBirth,
      required this.passportNumber,
      required this.passportExpiry,
      required this.nationality,
      required this.host,
      required this.purposeOfVisit,
      required this.arrivalDate,
      required this.expectedDepartureDate,
      required this.vehicleInformation,
      required this.observations,
      required this.createdAt,
      required this.msgRef,
      this.depMsgReff});

  factory NonResident.fromJson(List<dynamic> json) {
    final rfc1123Format = DateFormat('EEE, dd MMM yyyy HH:mm:ss \'GMT\'');
    return NonResident(
      id: json[0],
      firstName: json[1],
      lastName: json[2],
      dateOfBirth: rfc1123Format.parse(json[3]),
      placeOfBirth: json[4],
      passportNumber: json[5],
      passportExpiry: rfc1123Format.parse(json[6]),
      nationality: json[7],
      host: json[8],
      purposeOfVisit: json[9],
      arrivalDate: rfc1123Format.parse(json[10]),
      expectedDepartureDate: rfc1123Format.parse(json[11]),
      vehicleInformation: json[12],
      observations: json[13],
      createdAt: rfc1123Format.parse(json[14]),
      msgRef: json[15],
      depMsgReff: json[16],
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
      'passport_expiry': passportExpiry.toIso8601String(),
      'nationality': nationality,
      'host': host,
      'purpose_of_visit': purposeOfVisit,
      'arrival_date': arrivalDate.toIso8601String(),
      'expected_departure_date': expectedDepartureDate.toIso8601String(),
      'vehicle_information': vehicleInformation,
      'observations': observations,
      'created_at': createdAt.toIso8601String(),
      'msg_ref': msgRef,
      'depMsgReff': null
    };
  }
}
