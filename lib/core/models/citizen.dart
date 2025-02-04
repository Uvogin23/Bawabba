// ignore: unused_import
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Citizen {
  final int id;
  final String firstName;
  final String lastName;
  final DateTime dateOfBirth;
  final String placeOfBirth;
  final String passportNumber;
  final DateTime passportExpiry;
  final String fonction;
  final DateTime exitDate;
  final String address;
  final String vehicleType;
  final String plateNumber;
  final String observations;
  final DateTime createdAt;
  final String msgRef;
  final String? depMsgReff;
  final DateTime? entryDate;

  Citizen(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.dateOfBirth,
      required this.placeOfBirth,
      required this.passportNumber,
      required this.passportExpiry,
      required this.fonction,
      required this.exitDate,
      required this.address,
      required this.vehicleType,
      required this.plateNumber,
      required this.observations,
      required this.createdAt,
      required this.msgRef,
      this.depMsgReff,
      this.entryDate});

  // Factory constructor for creating a new Citizen instance from a map
  factory Citizen.fromJson(List<dynamic> json) {
    final rfc1123Format = DateFormat('EEE, dd MMM yyyy HH:mm:ss \'GMT\'');
    return Citizen(
      id: json[0],
      firstName: json[1],
      lastName: json[2],
      dateOfBirth: rfc1123Format.parse(json[3]),
      placeOfBirth: json[4],
      passportNumber: json[5],
      passportExpiry: rfc1123Format.parse(json[6]),
      fonction: json[7],
      exitDate: rfc1123Format.parse(json[8]),
      address: json[9],
      vehicleType: json[10],
      plateNumber: json[11],
      observations: json[12],
      createdAt: rfc1123Format.parse(json[13]),
      msgRef: json[14],
      depMsgReff: json[15],
      entryDate: json[16] != null ? rfc1123Format.parse(json[16]) : null,
    );
  }

  // Method for converting a Citizen instance to a map
  Map<String, dynamic> toJson() => {
        'id': id,
        'first_name': firstName,
        'last_name': lastName,
        'date_of_birth': dateOfBirth.toIso8601String(),
        'place_of_birth': placeOfBirth,
        'passport_number': passportNumber,
        'passport_expiry': passportExpiry.toIso8601String(),
        'fonction': fonction,
        'exit_date': exitDate.toIso8601String(),
        'address': address,
        'vehicle_type': vehicleType,
        'plate_number': plateNumber,
        'observations': observations,
        'created_at': createdAt.toIso8601String(),
        'msg_ref': msgRef,
        'depMsgReff': null,
        'entry_date': null
      };
}
