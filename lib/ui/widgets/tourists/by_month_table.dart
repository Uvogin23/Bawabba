import 'dart:convert';
import 'package:bawabba/core/models/tourist.dart';
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

void showTouristsByMonth(BuildContext context, int year) {
  Future<Map<String, dynamic>> fetchTouristsData(int year) async {
    final url = Uri.parse(
        'http://127.0.0.1:5000/api/tourists/monthly_counts?year=$year');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      print(response.body);
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  String _monthName(int month) {
    const months = [
      'جانفي',
      'فيفري',
      'مارس',
      'افريل',
      'ماي',
      'جوان',
      'جويلية',
      'أوت',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر'
    ];
    return months[month - 1];
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          " عدد السياح حسب الجنسيات خلال سنة $year",
          textAlign: TextAlign.right,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
            child: Container(
          padding: const EdgeInsets.all(10.0),
          width: 1200,
          child: FutureBuilder<Map<String, dynamic>>(
            future: fetchTouristsData(year),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No data available.'));
              }

              final data = snapshot.data!;
              final List<dynamic> countries = data['countries'];
              final int grandTotal = data['grand_total'];

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  children: [
                    Text(
                      'Grand Total: $grandTotal',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                        columns: [
                          const DataColumn(label: Text('Country')),
                          ...List.generate(12, (index) {
                            return DataColumn(
                              label: Text(_monthName(index + 1)),
                            );
                          }),
                          const DataColumn(label: Text('Total')),
                        ],
                        rows: countries.map((country) {
                          final String nationality = country['nationality'];
                          final List<dynamic> monthlyCounts =
                              country['monthly_counts'];
                          final int total = country['total'];

                          return DataRow(
                            cells: [
                              DataCell(Text(nationality)),
                              ...List.generate(12, (index) {
                                return DataCell(
                                    Text('${monthlyCounts[index]}'));
                              }),
                              DataCell(Text('$total')),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        )),
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
