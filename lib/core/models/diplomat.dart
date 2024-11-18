// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Diplomat {
  final int id;
  final String firstName;
  final String lastName;
  final DateTime dateOfBirth;
  final String? placeOfBirth;
  final String passportNumber;
  final DateTime? passportExpiry;
  final String diplomaticCardNumber;
  final String? fonction;
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

  Diplomat({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    this.placeOfBirth,
    required this.passportNumber,
    this.passportExpiry,
    required this.diplomaticCardNumber,
    this.fonction,
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
      passportExpiry: json[6] != null ? rfc1123Format.parse(json[6]) : null,
      diplomaticCardNumber: json[7],
      fonction: json[8],
      nationality: json[9],
      receivingAgency: json[10],
      circuit: json[11],
      arrivalDate: json[12] != null ? rfc1123Format.parse(json[12]) : null,
      expectedDepartureDate:
          json[13] != null ? rfc1123Format.parse(json[13]) : null,
      arrivalFlightInfo: json[14],
      departureFlightInfo: json[15],
      touristicGuide: json[16],
      createdAt: json[17] != null ? rfc1123Format.parse(json[17]) : null,
      msgRef: json[18],
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
      'diplomatic_card_number': diplomaticCardNumber,
      'fonction': fonction,
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

  static List<Diplomat> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map<Diplomat>((item) => Diplomat.fromJson(item)).toList();
  }
}
