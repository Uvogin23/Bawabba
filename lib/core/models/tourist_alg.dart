// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AlgerianTourist {
  final int id;
  final String firstName;
  final String lastName;
  final DateTime dateOfBirth;
  final String? placeOfBirth;
  final String idNumber;
  final String? receivingAgency;
  final String? circuit;
  final DateTime? arrivalDate;
  final String? touristicGuide;
  final String? msgRef;
  final DateTime? createdAt;

  AlgerianTourist({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    this.placeOfBirth,
    required this.idNumber,
    this.receivingAgency,
    this.circuit,
    this.arrivalDate,
    this.touristicGuide,
    this.msgRef,
    this.createdAt,
  });

  factory AlgerianTourist.fromJson(Map<String, dynamic> json) {
    final rfc1123Format = DateFormat('EEE, dd MMM yyyy HH:mm:ss \'GMT\'');
    return AlgerianTourist(
      id: json[0],
      firstName: json[1],
      lastName: json[2],
      dateOfBirth: rfc1123Format.parse(json[3]),
      placeOfBirth: json[4],
      idNumber: json[5],
      receivingAgency: json[6],
      circuit: json[7],
      arrivalDate: json[8] != null ? rfc1123Format.parse(json[8]) : null,
      touristicGuide: json[9],
      msgRef: json[10],
      createdAt: json[11] != null ? rfc1123Format.parse(json[11]) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'date_of_birth': dateOfBirth.toIso8601String(),
      'place_of_birth': placeOfBirth,
      'id_number': idNumber,
      'receiving_agency': receivingAgency,
      'circuit': circuit,
      'arrival_date': arrivalDate?.toIso8601String(),
      'touristic_guide': touristicGuide,
      'msg_ref': msgRef,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
