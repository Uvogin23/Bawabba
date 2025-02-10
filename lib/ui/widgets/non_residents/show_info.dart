import 'dart:convert';
import 'package:bawabba/core/models/non_resident.dart';
import 'package:bawabba/ui/widgets/tourists/tourists_table1.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

void viewNonResident(NonResident nonResident, BuildContext context) {
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
                  nonResident.firstName,
                  "اللقب",
                  nonResident.lastName,
                ),
                _buildTouristInfoRow(
                  "تاريخ الميلاد",
                  formatDate(nonResident.dateOfBirth),
                  "مكان الميلاد",
                  nonResident.placeOfBirth,
                ),
                // Row 2: Passport details
                _buildTouristInfoRow(
                  "رقم الجواز",
                  nonResident.passportNumber,
                  "تاريخ انتهاء الجواز",
                  formatDate(nonResident.passportExpiry),
                ),
                // Row 3: Arrival details
                _buildTouristInfoRow(
                  "تاريخ الوصول",
                  formatDate(nonResident.arrivalDate),
                  "معلومات المركبة",
                  nonResident.vehicleInformation,
                ),

                // Row 4: Departure details
                _buildTouristInfoRow(
                  "تاريخ المغادرة المتوقع",
                  formatDate(nonResident.expectedDepartureDate),
                  "المضيف",
                  nonResident.host,
                ),
                // Row 5: Additional details
                _buildTouristInfoRow(
                  "الجنسية",
                  nonResident.nationality,
                  "مرجع الرسالة",
                  nonResident.msgRef,
                ),
                _buildTouristInfoRow(
                  "الغرض من الزيارة",
                  nonResident.purposeOfVisit,
                  "ملاحظات",
                  nonResident.observations,
                ),
                _buildTouristInfoRow2(
                  "مرجع المغادرة",
                  nonResident.depMsgReff,
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
