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

void showDiplomatsByMonth(BuildContext context, int year) {
  Future<Map<String, dynamic>> fetchDiplomatsData(int year) async {
    final url =
        Uri.parse('${Config.baseUrl}/api/diplomats/monthly-counts?year=$year');
    final response = await http.get(url);

    if (response.statusCode == 200) {
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
          " عدد الدبلوماسيين حسب الجنسيات خلال سنة $year",
          textAlign: TextAlign.right,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
            child: Container(
          padding: const EdgeInsets.all(10.0),
          width: 1200,
          child: FutureBuilder<Map<String, dynamic>>(
            future: fetchDiplomatsData(year),
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
                      'العدد الإجمالي: $grandTotal',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                        headingRowColor: WidgetStateProperty.resolveWith(
                            (states) =>
                                const Color.fromARGB(255, 233, 191, 24)),
                        columns: [
                          const DataColumn(label: Text('الجنسية')),
                          ...List.generate(12, (index) {
                            return DataColumn(
                              label: Text(_monthName(index + 1)),
                            );
                          }),
                          const DataColumn(
                            label: Text('المجموع'),
                          ),
                        ],
                        rows: countries.map((country) {
                          final String nationality = country['nationality'];
                          final List<dynamic> monthlyCounts =
                              country['monthly_counts'];
                          final int total = country['total'];

                          return DataRow(
                            cells: [
                              DataCell(
                                  SelectableText(nationality, maxLines: 5)),
                              ...List.generate(12, (index) {
                                return DataCell(SelectableText(
                                    '${monthlyCounts[index]}',
                                    maxLines: 5));
                              }),
                              DataCell(SelectableText('$total', maxLines: 5)),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: const ButtonStyle(
                          elevation: WidgetStatePropertyAll(5),
                          backgroundColor:
                              WidgetStatePropertyAll(Config.colorPrimary)),
                      onPressed: () => _printTable(data, year),
                      child: const Text('طباعة الجدول',
                          style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255))),
                    ),
                  ],
                ),
              );
            },
          ),
        )),
        actions: [],
      );
    },
  );
}

void _printTable(Map<String, dynamic> data, int year) async {
  final List<dynamic> countries = data['countries'];
  final int grandTotal = data['grand_total'];
  final arabicFont = await _loadFont('assets/fonts/Cairo-Regular.ttf');

  final pdf = pw.Document();
  const int entriesPerPage = 11;
  final int pageCount = (countries.length / entriesPerPage).ceil();

  for (int page = 0; page < pageCount; page++) {
    final List<dynamic> pageCountries =
        countries.skip(page * entriesPerPage).take(entriesPerPage).toList();

    pdf.addPage(
      pw.Page(
        orientation: pw.PageOrientation.landscape,
        build: (pw.Context context) {
          return pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  "عدد السياح حسب الجنسية لسنة $year - صفحة ${page + 1} من $pageCount",
                  style: pw.TextStyle(
                    font: arabicFont,
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Table(
                  border: pw.TableBorder.all(),
                  columnWidths: {
                    0: const pw.FlexColumnWidth(1), // Nationality column
                    for (int i = 1; i <= 12; i++)
                      i: const pw.FlexColumnWidth(1), // Monthly columns
                    13: const pw.FlexColumnWidth(1), // Total column
                  },
                  children: [
                    pw.TableRow(
                      decoration: const pw.BoxDecoration(
                        color: PdfColors.grey200,
                      ),
                      children: [
                        pw.Container(
                          alignment: pw.Alignment.center,
                          child: pw.Text(
                            'Nation',
                            style: pw.TextStyle(
                              font: arabicFont,
                              fontWeight: pw.FontWeight.bold,
                            ),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                        ...List.generate(12, (index) {
                          return pw.Container(
                            alignment: pw.Alignment.center,
                            child: pw.Text(
                              _monthName(index + 1),
                              style: pw.TextStyle(
                                font: arabicFont,
                                fontWeight: pw.FontWeight.bold,
                              ),
                              textAlign: pw.TextAlign.center,
                            ),
                          );
                        }),
                        pw.Container(
                          alignment: pw.Alignment.center,
                          child: pw.Text(
                            'المجموع',
                            style: pw.TextStyle(
                              font: arabicFont,
                              fontWeight: pw.FontWeight.bold,
                            ),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    ...pageCountries.map((country) {
                      final String nationality = country['nationality'];
                      final List<dynamic> monthlyCounts = List.generate(
                          12, (i) => country['monthly_counts'][i] ?? 0);
                      final int total = country['total'];

                      return pw.TableRow(
                        children: [
                          pw.Container(
                            alignment: pw.Alignment.center,
                            child: pw.Text(
                              nationality,
                              style: pw.TextStyle(font: arabicFont),
                              textAlign: pw.TextAlign.center,
                            ),
                          ),
                          ...List.generate(12, (index) {
                            return pw.Container(
                              alignment: pw.Alignment.center,
                              child: pw.Text(
                                '${monthlyCounts[index]}',
                                textAlign: pw.TextAlign.center,
                              ),
                            );
                          }),
                          pw.Container(
                            alignment: pw.Alignment.center,
                            child: pw.Text(
                              '$total',
                              textAlign: pw.TextAlign.center,
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ],
                ),
                if (page == pageCount - 1) ...[
                  pw.SizedBox(height: 10),
                  pw.Text(
                    'العدد الإجمالي: $grandTotal',
                    style: pw.TextStyle(
                      font: arabicFont,
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => pdf.save(),
  );
}

String _monthName(int month) {
  const months = [
    'Jan',
    'Fev',
    'Mars',
    'Avr',
    'Mai',
    'Juin',
    'Jui',
    'Aout',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  return months[month - 1];
}

Future<pw.Font> _loadFont(String path) async {
  final fontData = await rootBundle.load(path);
  return pw.Font.ttf(fontData.buffer.asByteData());
}
