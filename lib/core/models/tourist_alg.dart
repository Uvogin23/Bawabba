// ignore_for_file: unused_import

import 'package:flutter/material.dart';

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
    return AlgerianTourist(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      dateOfBirth: DateTime.parse(json['date_of_birth']),
      placeOfBirth: json['place_of_birth'],
      idNumber: json['id_number'],
      receivingAgency: json['receiving_agency'],
      circuit: json['circuit'],
      arrivalDate: json['arrival_date'] != null
          ? DateTime.parse(json['arrival_date'])
          : null,
      touristicGuide: json['touristic_guide'],
      msgRef: json['msg_ref'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
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
