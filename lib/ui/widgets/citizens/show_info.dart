import 'dart:convert';
import 'package:bawabba/core/models/citizen.dart';
import 'package:bawabba/ui/widgets/tourists/tourists_table1.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

void viewCitizen(Citizen citizen, BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          "معلومات الرعية الأجنبية",
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
                _buildTouristInfoRow(
                  "الإسم",
                  citizen.firstName,
                  "اللقب",
                  citizen.lastName,
                ),
                _buildTouristInfoRow(
                  "تاريخ الميلاد",
                  formatDate(citizen.dateOfBirth),
                  "مكان الميلاد",
                  citizen.placeOfBirth,
                ),
                // Row 2: Passport details
                _buildTouristInfoRow(
                  "رقم الجواز",
                  citizen.passportNumber,
                  "تاريخ انتهاء الجواز",
                  formatDate(citizen.passportExpiry),
                ),
                // Row 3: Arrival details
                _buildTouristInfoRow(
                  "العنوان",
                  citizen.address,
                  "الوظيفة",
                  citizen.fonction,
                ),

                // Row 4: Departure details
                _buildTouristInfoRow(
                  "تاريخ الحركة",
                  formatDate(citizen.exitDate),
                  "معلومات المركبة",
                  citizen.vehicleType,
                ),
                // Row 5: Additional details
                _buildTouristInfoRow(
                  "رقم التسجيل",
                  citizen.plateNumber,
                  "المرجع ",
                  citizen.msgRef,
                ),
                _buildTouristInfoRow(
                  "ملاحظات",
                  citizen.observations,
                  "تاريخ إنشاء الحركة",
                  formatDate(citizen.createdAt),
                ),
                _buildTouristInfoRow3(
                  "تاريخ العودة ",
                  citizen.entryDate,
                ),
                _buildTouristInfoRow2(
                  "مرجع المغادرة",
                  citizen.depMsgReff,
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

Widget _buildTouristInfoRow(
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

Widget _buildTouristInfoRow2(
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
    'السائح لا يزال خارج التراب الوطني ',
    style:
        TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.red),
  );
}

Widget _buildTouristInfoRow3(
  String label1,
  DateTime? value1,
) {
  if (value1 != null) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildInfoColumn2(label1, value1),
        ],
      ),
    );
  }
  return const Text(
    'السائح لا يزال خارج التراب الوطني ',
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

Widget _buildInfoColumn2(String label, DateTime value) {
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
          formatDate(value),
          style: const TextStyle(fontSize: 14),
        ),
      ],
    ),
  );
}
