// ignore: unused_import
import 'package:flutter/material.dart';

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
  factory Citizen.fromJson(Map<String, dynamic> json) => Citizen(
        id: json['id'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        dateOfBirth: DateTime.parse(json['date_of_birth']),
        placeOfBirth: json['place_of_birth'],
        passportNumber: json['passport_number'],
        passportExpiry: json['passport_expiry'] != null
            ? DateTime.parse(json['passport_expiry'])
            : null,
        fonction: json['fonction'],
        exitDate: DateTime.parse(json['exit_date']),
        entryDate: json['entry_date'] != null
            ? DateTime.parse(json['entry_date'])
            : null,
        messageReference: json['message_reference'],
        address: json['address'],
        vehicleType: json['vehicle_type'],
        plateNumber: json['plate_number'],
        observations: json['observations'],
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'])
            : null,
        msgRef: json['msg_ref'],
      );

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
