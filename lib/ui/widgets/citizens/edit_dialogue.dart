import 'dart:convert';
import 'package:bawabba/core/services/config.dart';
import 'package:bawabba/ui/screens/citizen_screen.dart';
import 'package:bawabba/ui/screens/non_residents_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void showUpdateCitizenDialog(
  BuildContext context,
  int nonResidentId,
) {
  final _formKey = GlobalKey<FormState>();

  final fonctionController = TextEditingController();
  final addressController = TextEditingController();
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
                  fonctionController,
                  "الوظيفة",
                ),
                _buildTextField(
                  addressController,
                  "العنوان",
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
                if (fonctionController.text.isNotEmpty)
                  'fonction': fonctionController.text,
                if (addressController.text.isNotEmpty)
                  'address': addressController.text,
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
                await updateCitizenAPI(nonResidentId, updatedData);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم تحديث المعلومات بنجاح')),
                );
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CitizenHome()),
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

Future<void> updateCitizenAPI(int id, Map<String, dynamic> updatedData) async {
  final url = Uri.parse('${Config.baseUrl}/api/citizens/Update/$id');
  final response = await http.put(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(updatedData),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to update non_residents: ${response.body}');
  }
}
