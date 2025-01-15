import 'dart:convert';
import 'package:bawabba/core/models/tourist.dart';
import 'package:bawabba/core/services/config.dart';
import 'package:bawabba/ui/widgets/tourists/edit_dialogue.dart';
import 'package:bawabba/ui/widgets/tourists/show_info.dart';
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

Future<List<Tourist>> fetchHistoryTourists() async {
  final response =
      await http.get(Uri.parse('${Config.baseUrl}/api/tourists/history'));

  if (response.statusCode == 200) {
    try {
      List<dynamic> data = json.decode(response.body);

      List<Tourist> list =
          data.map<Tourist>((item) => Tourist.fromJson(item)).toList();

      return list;
    } catch (e) {
      rethrow; // Re-throw the exception for handling elsewhere
    }
  } else {
    throw Exception('Failed to load tourists: ${response.statusCode}');
  }
}

class HistoryTable extends StatefulWidget {
  const HistoryTable({Key? key}) : super(key: key);

  @override
  State<HistoryTable> createState() => _HistoryTable();
}

class _HistoryTable extends State<HistoryTable> {
  late Future<List<Tourist>> touristsFuture;
  late List<Tourist> tourists;
  bool isAscending = true;
  int? sortColumnIndex;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    touristsFuture = fetchHistoryTourists();
    tourists = [];
  }

  void sortData(int columnIndex, bool ascending) {
    setState(() {
      isAscending = ascending;
      sortColumnIndex = columnIndex;
      if (columnIndex == 0) {
        tourists.sort(
            (a, b) => ascending ? a.id.compareTo(b.id) : b.id.compareTo(a.id));
      } else if (columnIndex == 1) {
        tourists.sort((a, b) => ascending
            ? a.firstName.compareTo(b.firstName)
            : b.firstName.compareTo(a.firstName));
      } else if (columnIndex == 2) {
        tourists.sort((a, b) => ascending
            ? a.lastName.compareTo(b.lastName)
            : b.lastName.compareTo(a.lastName));
      } else if (columnIndex == 3) {
        tourists.sort((a, b) => ascending
            ? a.nationality.compareTo(b.nationality)
            : b.nationality.compareTo(a.nationality));
      } else if (columnIndex == 6) {
        tourists.sort((a, b) => ascending
            ? a.msgRef.compareTo(b.msgRef)
            : b.msgRef.compareTo(a.msgRef));
      } else if (columnIndex == 7) {
        tourists.sort((a, b) => ascending
            ? a.receivingAgency.compareTo(b.receivingAgency)
            : b.receivingAgency.compareTo(a.receivingAgency));
      }
    });
  }

  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (BuildContext context, setState) {
      return AlertDialog(
          title: const Text(
            "قائمة السياح الذين غادروا إقليم ولاية جانت",
            textAlign: TextAlign.right,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
              child: Container(
            height: 500,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 30,
                ),
                FutureBuilder<List<Tourist>>(
                  future: touristsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                          child: Text("لا يوجد سياح بإقليم الولاية"));
                    } else {
                      tourists = snapshot.data!;
                      return Expanded(
                          child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: DataTable(
                          columnSpacing: 40.0,
                          headingRowHeight: 40.0,
                          headingRowColor: WidgetStateProperty.resolveWith(
                              (states) => Config.colorPrimary),
                          sortColumnIndex: sortColumnIndex,
                          sortAscending: isAscending,
                          columns: [
                            DataColumn(
                              label: const Text(
                                "الرقم",
                                style: TextStyle(color: Colors.white),
                              ),
                              onSort: (columnIndex, ascending) {
                                sortData(columnIndex, ascending);
                              },
                            ),
                            DataColumn(
                              label: const Text(
                                "الإسم",
                                style: TextStyle(color: Colors.white),
                              ),
                              onSort: (columnIndex, ascending) {
                                sortData(columnIndex, ascending);
                              },
                            ),
                            DataColumn(
                              label: const Text(
                                "اللقب",
                                style: TextStyle(color: Colors.white),
                              ),
                              onSort: (columnIndex, ascending) {
                                sortData(columnIndex, ascending);
                              },
                            ),
                            DataColumn(
                              label: const Text(
                                " الجنسية",
                                style: TextStyle(color: Colors.white),
                              ),
                              onSort: (columnIndex, ascending) {
                                sortData(columnIndex, ascending);
                              },
                            ),
                            const DataColumn(
                              label: Text(
                                "تاريخ الوصول",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            const DataColumn(
                              label: Text(
                                "يغادر يوم",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            DataColumn(
                              label: const Text(
                                "المرجع",
                                style: TextStyle(color: Colors.white),
                              ),
                              onSort: (columnIndex, ascending) {
                                sortData(columnIndex, ascending);
                              },
                            ),
                            DataColumn(
                              label: const Text(
                                "الوكالة السياحية",
                                style: TextStyle(color: Colors.white),
                              ),
                              onSort: (columnIndex, ascending) {
                                sortData(columnIndex, ascending);
                              },
                            ),
                            const DataColumn(
                              label: Text(
                                "",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                          rows: tourists.map((tourist) {
                            return DataRow(
                              color:
                                  WidgetStateProperty.all(Colors.transparent),
                              cells: [
                                DataCell(SelectableText(tourist.id.toString(),
                                    maxLines: 5)),
                                DataCell(SelectableText(tourist.firstName,
                                    maxLines: 5)),
                                DataCell(SelectableText(tourist.lastName,
                                    maxLines: 5)),
                                DataCell(SelectableText(tourist.nationality,
                                    maxLines: 5)),
                                DataCell(SelectableText(
                                    formatDate(tourist.arrivalDate),
                                    maxLines: 5)),
                                DataCell(SelectableText(
                                    formatDate(tourist.expectedDepartureDate),
                                    maxLines: 5)),
                                DataCell(SelectableText(tourist.msgRef,
                                    maxLines: 5)),
                                DataCell(SelectableText(tourist.receivingAgency,
                                    maxLines: 5)),
                                DataCell(
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                            Icons.remove_red_eye_outlined),
                                        onPressed: () =>
                                            viewTourist(tourist, context),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ));
                    }
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(100, 30, 8, 8),
                      child: ElevatedButton(
                        style: const ButtonStyle(
                            elevation: WidgetStatePropertyAll(5),
                            backgroundColor:
                                WidgetStatePropertyAll(Config.colorPrimary)),
                        onPressed: () async {
                          if (tourists.isNotEmpty) {
                            await _printDataTable(
                                tourists); // Pass employees list here
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("لا توجد بيانات للطباعة")),
                            );
                          }
                        },
                        child: const Text(
                          'طباعة الجدول',
                          style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          )));
    });
  }
}

String formatDate(DateTime date) {
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  return formatter.format(date);
}

Future<void> _printDataTable(List<Tourist> tourists) async {
  final pdf = pw.Document();
  final arabicFont = await _loadFont('assets/fonts/Cairo-Regular.ttf');

  final headers = [
    'المرجع',
    'تاريخ المغادرة',
    'الوكالة',
    'جواز السفر',
    'معلومات الوصول',
    'تاريخ الوصول',
    'الجنسية',
    'اللقب',
    'الإسم',
    'رقم',
  ];

  // Convert tourists data to rows
  final dataRows = tourists.map((tourist) {
    return [
      tourist.msgRef,
      formatDate(tourist.expectedDepartureDate),
      tourist.receivingAgency,
      tourist.passportNumber,
      tourist.arrivalFlightInfo,
      formatDate(tourist.arrivalDate),
      tourist.nationality,
      tourist.lastName,
      tourist.firstName,
      tourist.id.toString(),
    ];
  }).toList();

  const int rowsPerPage = 15; // Set a fixed number of rows per page
  int currentRow = 0;

  // Loop through the rows and paginate
  while (currentRow < dataRows.length) {
    final pageRows = dataRows.sublist(
      currentRow,
      (currentRow + rowsPerPage > dataRows.length)
          ? dataRows.length
          : currentRow + rowsPerPage,
    );

    pdf.addPage(
      pw.Page(
        orientation: pw.PageOrientation.landscape,
        build: (context) {
          return pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.TableHelper.fromTextArray(
              headers: headers,
              data: pageRows,
              headerStyle: pw.TextStyle(
                font: arabicFont,
                fontSize: 12,
                fontWeight: pw.FontWeight.bold,
              ),
              cellStyle: pw.TextStyle(
                font: arabicFont,
                fontSize: 10,
              ),
              cellAlignment: pw.Alignment.centerRight,
            ),
          );
        },
      ),
    );

    currentRow += rowsPerPage; // Move to the next set of rows
  }

  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => pdf.save(),
  );
}

Future<pw.Font> _loadFont(String path) async {
  final fontData = await rootBundle.load(path);
  return pw.Font.ttf(fontData.buffer.asByteData());
}
