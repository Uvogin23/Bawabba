// ignore_for_file: unused_import

import 'package:flutter/material.dart';

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

  factory Tourist.fromJson(Map<String, dynamic> json) {
    return Tourist(
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
      receivingAgency: json['receiving_agency'],
      circuit: json['circuit'],
      arrivalDate: json['arrival_date'] != null
          ? DateTime.parse(json['arrival_date'])
          : null,
      expectedDepartureDate: json['expected_departure_date'] != null
          ? DateTime.parse(json['expected_departure_date'])
          : null,
      arrivalFlightInfo: json['arrival_flight_info'],
      departureFlightInfo: json['departure_flight_info'],
      touristicGuide: json['touristic_guide'],
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
