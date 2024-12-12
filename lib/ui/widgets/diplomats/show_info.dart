import 'dart:convert';
import 'package:bawabba/core/models/diplomat.dart';
import 'package:bawabba/core/models/tourist.dart';
import 'package:bawabba/ui/widgets/tourists/tourists_table1.dart';
import 'package:flutter/material.dart';

void viewDiplomat(Diplomat diplomat, BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          "معلومات الدبلوماسي",
          textAlign: TextAlign.right,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10.0),
            width: 500,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row 1: Name and Date of Birth
                _buildDiplomatInfoRow(
                  "الإسم",
                  diplomat.firstName,
                  "اللقب",
                  diplomat.lastName,
                ),
                _buildDiplomatInfoRow(
                  "تاريخ الميلاد",
                  formatDate(diplomat.dateOfBirth),
                  "مكان الميلاد",
                  diplomat.placeOfBirth,
                ),
                // Row 2: Passport details
                _buildDiplomatInfoRow(
                  "رقم الجواز",
                  diplomat.passportNumber,
                  "تاريخ انتهاء الجواز",
                  formatDate(diplomat.passportExpiry),
                ),
                _buildDiplomatInfoRow(
                  "رقم البطاقة الدبلوماسية",
                  diplomat.diplomaticCardNumber,
                  "الوظيفة",
                  diplomat.fonction,
                ),
                // Row 3: Arrival details
                _buildDiplomatInfoRow(
                  "تاريخ الوصول",
                  formatDate(diplomat.arrivalDate),
                  "معلومات الوصول",
                  diplomat.arrivalFlightInfo,
                ),

                // Row 4: Departure details
                _buildDiplomatInfoRow(
                  "تاريخ المغادرة المتوقع",
                  formatDate(diplomat.expectedDepartureDate),
                  "معلومات  المغادرة",
                  diplomat.departureFlightInfo,
                ),
                // Row 5: Additional details
                _buildDiplomatInfoRow(
                  "الدليل السياحي",
                  diplomat.touristicGuide,
                  "مرجع الرسالة",
                  diplomat.msgRef,
                ),
                _buildDiplomatInfoRow(
                  "الجنسية",
                  diplomat.nationality,
                  "تاريخ الإنشاء",
                  formatDate(diplomat.createdAt),
                ),
                _buildDiplomatInfoRow(
                  "الوكالة السياحية",
                  diplomat.receivingAgency,
                  "المسار السياحي",
                  diplomat.circuit,
                ),
                _buildDiplomatInfoRow2(
                  "مرجع المغادرة",
                  diplomat.depMsgReff,
                ),
              ],
            ),
          ),
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("إغلاق"),
            ),
          ),
        ],
      );
    },
  );
}

Widget _buildDiplomatInfoRow(
  String label1,
  String value1,
  String label2,
  String value2,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildInfoColumn(label1, value1),
        const SizedBox(width: 20),
        _buildInfoColumn(label2, value2),
      ],
    ),
  );
}

Widget _buildDiplomatInfoRow2(
  String label1,
  String? value1,
) {
  if (value1 != null) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildInfoColumn(label1, value1),
        ],
      ),
    );
  }
  return const Text(
    'السائح لا يزال متواجدا بإقليم الإختصاص ',
    style:
        TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.red),
  );
}

Widget _buildInfoColumn(String label, String value) {
  return Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        SelectableText(
          value,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    ),
  );
}
