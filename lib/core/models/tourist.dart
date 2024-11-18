// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Tourist {
  final int id;
  final String firstName;
  final String lastName;
  final DateTime dateOfBirth;
  final String? placeOfBirth;
  final String passportNumber;
  final DateTime? passportExpiry;
  final String? nationality;
  final String? receivingAgency;
  final String? circuit;
  final DateTime? arrivalDate;
  final DateTime? expectedDepartureDate;
  final String? arrivalFlightInfo;
  final String? departureFlightInfo;
  final String? touristicGuide;
  final DateTime? createdAt;
  final String? msgRef;

  Tourist({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    this.placeOfBirth,
    required this.passportNumber,
    this.passportExpiry,
    this.nationality,
    this.receivingAgency,
    this.circuit,
    this.arrivalDate,
    this.expectedDepartureDate,
    this.arrivalFlightInfo,
    this.departureFlightInfo,
    this.touristicGuide,
    this.createdAt,
    this.msgRef,
  });

  factory Tourist.fromJson(List<dynamic> json) {
    final rfc1123Format = DateFormat('EEE, dd MMM yyyy HH:mm:ss \'GMT\'');
    return Tourist(
      id: json[0],
      firstName: json[1],
      lastName: json[2],
      dateOfBirth: rfc1123Format.parse(json[3]),
      placeOfBirth: json[4],
      passportNumber: json[5],
      passportExpiry: json[6] != null ? rfc1123Format.parse(json[6]) : null,
      nationality: json[7],
      receivingAgency: json[8],
      circuit: json[9],
      arrivalDate: json[10] != null ? rfc1123Format.parse(json[10]) : null,
      expectedDepartureDate:
          json[11] != null ? rfc1123Format.parse(json[11]) : null,
      arrivalFlightInfo: json[12],
      departureFlightInfo: json[13],
      touristicGuide: json[14],
      createdAt: json[15] != null ? rfc1123Format.parse(json[15]) : null,
      msgRef: json[16],
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
      'receiving_agency': receivingAgency,
      'circuit': circuit,
      'arrival_date': arrivalDate?.toIso8601String(),
      'expected_departure_date': expectedDepartureDate?.toIso8601String(),
      'arrival_flight_info': arrivalFlightInfo,
      'departure_flight_info': departureFlightInfo,
      'touristic_guide': touristicGuide,
      'created_at': createdAt?.toIso8601String(),
      'msg_ref': msgRef,
    };
  }
}
