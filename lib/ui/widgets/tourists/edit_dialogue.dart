import 'dart:convert';
import 'package:bawabba/core/models/tourist.dart';
import 'package:bawabba/core/services/config.dart';
import 'package:bawabba/ui/screens/tourists_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void showUpdateTouristDialog(
  BuildContext context,
  int touristId,
) {
  final _formKey = GlobalKey<FormState>();

  final receivingAgencyController = TextEditingController();
  final circuitController = TextEditingController();
  final expectedDepartureDateController = TextEditingController();
  final arrivalFlightInfoController = TextEditingController();
  final departureFlightInfoController = TextEditingController();
  final touristicGuideController = TextEditingController();
  final msgRefController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      Widget _buildTextField(TextEditingController controller, String label) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              border: const OutlineInputBorder(),
              filled: true,
              fillColor: Colors.grey[200],
            ),
          ),
        );
      }

      Widget _buildDatePickerField(
          TextEditingController controller, String label) {
        final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: GestureDetector(
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context, // Ensure correct context is used
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime(2100),
              );
              if (pickedDate != null) {
                controller.text = dateFormat.format(pickedDate);
                // Format as yyyy-MM-dd
              }
            },
            child: AbsorbPointer(
              child: TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: label,
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                  suffixIcon: const Icon(Icons.calendar_today),
                ),
              ),
            ),
          ),
        );
      }

      return AlertDialog(
        title: const Text(
          " تحديث المعلومات",
          textAlign: TextAlign.center,
        ),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(
                  receivingAgencyController,
                  "الوكالة السياحية",
                ),
                _buildTextField(
                  circuitController,
                  "المسار السياحي",
                ),
                _buildDatePickerField(
                  expectedDepartureDateController,
                  "تاريخ المغادرة",
                ),
                _buildTextField(
                  arrivalFlightInfoController,
                  "معلومات الوصول",
                ),
                _buildTextField(
                  departureFlightInfoController,
                  "معلومات المغادرة",
                ),
                _buildTextField(
                  touristicGuideController,
                  "المرشد السياحي",
                ),
                _buildTextField(
                  msgRefController,
                  "المرجع",
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("إلغاء"),
          ),
          ElevatedButton(
            onPressed: () async {
              final updatedData = {
                if (receivingAgencyController.text.isNotEmpty)
                  'receiving_agency': receivingAgencyController.text,
                if (circuitController.text.isNotEmpty)
                  'circuit': circuitController.text,
                if (expectedDepartureDateController.text.isNotEmpty)
                  'expected_departure_date':
                      expectedDepartureDateController.text,
                if (arrivalFlightInfoController.text.isNotEmpty)
                  'arrival_flight_info': arrivalFlightInfoController.text,
                if (departureFlightInfoController.text.isNotEmpty)
                  'departure_flight_info': departureFlightInfoController.text,
                if (touristicGuideController.text.isNotEmpty)
                  'touristic_guide': touristicGuideController.text,
                if (msgRefController.text.isNotEmpty)
                  'msg_ref': msgRefController.text,
              };

              if (updatedData.isEmpty) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('يجب ملأ خانة واحدة على الأقل.'),
                  ),
                );
                return;
              }

              try {
                await updateTouristAPI(touristId, updatedData);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم تحديث المعلومات بنجاح')),
                );
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TouristsHome()),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('خلل بتحديث المعلومات: $e')),
                );
              }
            },
            child: const Text("تحديث"),
          ),
        ],
      );
    },
  );
}

Future<void> updateTouristAPI(int id, Map<String, dynamic> updatedData) async {
  final url = Uri.parse('${Config.baseUrl}/api/tourists/Update/$id');
  final response = await http.put(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(updatedData),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to update tourist: ${response.body}');
  }
}
