// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Diplomat {
  final int id;
  final String firstName;
  final String lastName;
  final DateTime dateOfBirth;
  final String placeOfBirth;
  final String passportNumber;
  final DateTime passportExpiry;
  final String diplomaticCardNumber;
  final String fonction;
  final String nationality;
  final String receivingAgency;
  final String circuit;
  final DateTime arrivalDate;
  final DateTime expectedDepartureDate;
  final String arrivalFlightInfo;
  final String departureFlightInfo;
  final String touristicGuide;
  final DateTime createdAt;
  final String msgRef;
  final String? depMsgReff;

  Diplomat(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.dateOfBirth,
      required this.placeOfBirth,
      required this.passportNumber,
      required this.passportExpiry,
      required this.diplomaticCardNumber,
      required this.fonction,
      required this.nationality,
      required this.receivingAgency,
      required this.circuit,
      required this.arrivalDate,
      required this.expectedDepartureDate,
      required this.arrivalFlightInfo,
      required this.departureFlightInfo,
      required this.touristicGuide,
      required this.createdAt,
      required this.msgRef,
      this.depMsgReff});

  /// Factory constructor to create a Diplomat from a single list
  factory Diplomat.fromJson(List<dynamic> json) {
    final rfc1123Format = DateFormat('EEE, dd MMM yyyy HH:mm:ss \'GMT\'');
    return Diplomat(
        id: json[0],
        firstName: json[1],
        lastName: json[2],
        dateOfBirth: rfc1123Format.parse(json[3]),
        placeOfBirth: json[4],
        passportNumber: json[5],
        passportExpiry: rfc1123Format.parse(json[6]),
        diplomaticCardNumber: json[7],
        fonction: json[8],
        nationality: json[9],
        receivingAgency: json[10],
        circuit: json[11],
        arrivalDate: rfc1123Format.parse(json[12]),
        expectedDepartureDate: rfc1123Format.parse(json[13]),
        arrivalFlightInfo: json[14],
        departureFlightInfo: json[15],
        touristicGuide: json[16],
        createdAt: rfc1123Format.parse(json[17]),
        msgRef: json[18],
        depMsgReff: json[19]);
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
      'diplomatic_card_number': diplomaticCardNumber,
      'fonction': fonction,
      'nationality': nationality,
      'receiving_agency': receivingAgency,
      'circuit': circuit,
      'arrival_date': arrivalDate.toIso8601String(),
      'expected_departure_date': expectedDepartureDate.toIso8601String(),
      'arrival_flight_info': arrivalFlightInfo,
      'departure_flight_info': departureFlightInfo,
      'touristic_guide': touristicGuide,
      'created_at': createdAt.toIso8601String(),
      'msg_ref': msgRef,
    };
  }
}
