// ignore: unused_import
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Citizen {
  final int id;
  final String firstName;
  final String lastName;
  final DateTime dateOfBirth;
  final String? placeOfBirth;
  final String passportNumber;
  final DateTime? passportExpiry;
  final String? fonction;
  final DateTime exitDate;
  final DateTime? entryDate;
  final String? messageReference;
  final String? address;
  final String? vehicleType;
  final String? plateNumber;
  final String? observations;
  final DateTime? createdAt;
  final String? msgRef;

  Citizen({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    this.placeOfBirth,
    required this.passportNumber,
    this.passportExpiry,
    this.fonction,
    required this.exitDate,
    this.entryDate,
    this.messageReference,
    this.address,
    this.vehicleType,
    this.plateNumber,
    this.observations,
    this.createdAt,
    this.msgRef,
  });

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
      passportExpiry: json[6] != null ? rfc1123Format.parse(json[6]) : null,
      fonction: json[7],
      exitDate: rfc1123Format.parse(json[8]),
      entryDate: json[9] != null ? rfc1123Format.parse(json[9]) : null,
      messageReference: json[10],
      address: json[11],
      vehicleType: json[12],
      plateNumber: json[13],
      observations: json[14],
      createdAt: json[15] != null ? rfc1123Format.parse(json[15]) : null,
      msgRef: json[16],
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
        'passport_expiry': passportExpiry?.toIso8601String(),
        'fonction': fonction,
        'exit_date': exitDate.toIso8601String(),
        'entry_date': entryDate?.toIso8601String(),
        'message_reference': messageReference,
        'address': address,
        'vehicle_type': vehicleType,
        'plate_number': plateNumber,
        'observations': observations,
        'created_at': createdAt?.toIso8601String(),
        'msg_ref': msgRef,
      };
}
