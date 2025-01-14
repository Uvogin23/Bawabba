import 'dart:convert';
import 'package:bawabba/core/models/tourist.dart';
import 'package:bawabba/core/services/config.dart';
import 'package:bawabba/ui/widgets/tourists/tourists_table1.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:window_manager/window_manager.dart';
import 'package:bawabba/core/services/card_stats.dart';
import 'package:bawabba/core/models/user.dart';
import 'package:bawabba/core/services/auth_provider.dart';
import 'package:bawabba/main.dart';
import 'package:provider/provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

void showDiplomatsByNationality(BuildContext context) {
  Future<List<Map<String, dynamic>>> fetchDiplomatsByNationality() async {
    final url = Uri.parse('${Config.baseUrl}/api/diplomats/counts');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data =
          json.decode(response.body); // Decode the JSON response
      return data.map((item) => item as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          " عدد الدبلوماسيين المسجلين بالتطبيقة حسب الجنسية ",
          textAlign: TextAlign.right,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
            child: Container(
          padding: const EdgeInsets.all(10.0),
          width: 450,
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future:
                fetchDiplomatsByNationality(), // Your data fetching function
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                    child: SelectableText('Error1: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No data available.'));
              }

              final data = snapshot.data!;

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: DataTable(
                    headingRowColor: WidgetStateProperty.resolveWith(
                        (states) => Config.colorPrimary),
                    columns: const [
                      DataColumn(
                          label: Text(
                        'الجنسية',
                        style: TextStyle(color: Colors.white),
                      )),
                      DataColumn(
                          label: Text(
                        'العدد',
                        style: TextStyle(color: Colors.white),
                      )),
                    ],
                    rows: data.map((country) {
                      return DataRow(cells: [
                        DataCell(Text(
                          country['nationality'],
                        )),
                        DataCell(Text('${country['count']}')),
                      ]);
                    }).toList(),
                  ),
                ),
              );
            },
          ),
        )),
        actions: const [],
      );
    },
  );
}
