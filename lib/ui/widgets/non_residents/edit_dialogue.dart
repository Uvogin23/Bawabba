import 'dart:convert';
import 'package:bawabba/core/services/config.dart';
import 'package:bawabba/ui/screens/non_residents_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void showUpdateNonResidentDialog(
  BuildContext context,
  int nonResidentId,
) {
  final _formKey = GlobalKey<FormState>();

  final purposeOfVisitController = TextEditingController();
  final hostController = TextEditingController();
  final expectedDepartureDateController = TextEditingController();
  final vehiculeinformationController = TextEditingController();
  final observationsController = TextEditingController();
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
                  purposeOfVisitController,
                  "الغرض من الزيارة",
                ),
                _buildTextField(
                  hostController,
                  "المضيف",
                ),
                _buildDatePickerField(
                  expectedDepartureDateController,
                  "تاريخ المغادرة",
                ),
                _buildTextField(
                  vehiculeinformationController,
                  "معلومات المركبة",
                ),
                _buildTextField(
                  observationsController,
                  "الملاحظات",
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
                if (purposeOfVisitController.text.isNotEmpty)
                  'purpose_of_visit': purposeOfVisitController.text,
                if (hostController.text.isNotEmpty) 'host': hostController.text,
                if (expectedDepartureDateController.text.isNotEmpty)
                  'expected_departure_date':
                      expectedDepartureDateController.text,
                if (vehiculeinformationController.text.isNotEmpty)
                  'vehicle_information': vehiculeinformationController.text,
                if (observationsController.text.isNotEmpty)
                  'observations': observationsController.text,
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
                await updateNonResidentAPI(nonResidentId, updatedData);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم تحديث المعلومات بنجاح')),
                );
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NonResidentsHome()),
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

Future<void> updateNonResidentAPI(
    int id, Map<String, dynamic> updatedData) async {
  final url = Uri.parse('${Config.baseUrl}/api/non_residents/Update/$id');
  final response = await http.put(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(updatedData),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to update non_residents: ${response.body}');
  }
}
