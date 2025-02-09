import 'dart:convert';
import 'package:bawabba/core/models/citizen.dart';
import 'package:bawabba/core/services/config.dart';
import 'package:bawabba/ui/widgets/citizens/show_info.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

Future<List<Citizen>> fetchHistoryCitizens() async {
  final response =
      await http.get(Uri.parse('${Config.baseUrl}/api/citizens/history'));

  if (response.statusCode == 200) {
    try {
      List<dynamic> data = json.decode(response.body);

      List<Citizen> list =
          data.map<Citizen>((item) => Citizen.fromJson(item)).toList();
      print(list.first.depMsgReff);
      return list;
    } catch (e) {
      rethrow; // Re-throw the exception for handling elsewhere
    }
  } else {
    throw Exception('Failed to load citizen: ${response.body}');
  }
}

class CHistoryTable extends StatefulWidget {
  const CHistoryTable({Key? key}) : super(key: key);

  @override
  State<CHistoryTable> createState() => _CHistoryTable();
}

class _CHistoryTable extends State<CHistoryTable> {
  late Future<List<Citizen>> citizensFuture;
  late List<Citizen> citizens;
  bool isAscending = true;
  int? sortColumnIndex;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    citizensFuture = fetchHistoryCitizens();
    citizens = [];
  }

  void sortData(int columnIndex, bool ascending) {
    setState(() {
      isAscending = ascending;
      sortColumnIndex = columnIndex;
      if (columnIndex == 0) {
        citizens.sort(
            (a, b) => ascending ? a.id.compareTo(b.id) : b.id.compareTo(a.id));
      } else if (columnIndex == 1) {
        citizens.sort((a, b) => ascending
            ? a.firstName.compareTo(b.firstName)
            : b.firstName.compareTo(a.firstName));
      } else if (columnIndex == 2) {
        citizens.sort((a, b) => ascending
            ? a.lastName.compareTo(b.lastName)
            : b.lastName.compareTo(a.lastName));
      } else if (columnIndex == 5) {
        citizens.sort((a, b) => ascending
            ? a.msgRef.compareTo(b.msgRef)
            : b.msgRef.compareTo(a.msgRef));
      }
    });
  }

  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (BuildContext context, setState) {
      return AlertDialog(
          title: const Text(
            "قائمة المواطنين العائدين الى التراب الوطني",
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
                FutureBuilder<List<Citizen>>(
                  future: citizensFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                          child: Text("لا يوجد رعايا بإقليم الولاية"));
                    } else {
                      citizens = snapshot.data!;
                      return Expanded(
                          child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: DataTable(
                          columnSpacing: 40.0,
                          headingRowHeight: 40.0,
                          headingRowColor: WidgetStateProperty.resolveWith(
                              (states) => Color.fromARGB(255, 7, 80, 122)),
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
                                " الوظيفة",
                                style: TextStyle(color: Colors.white),
                              ),
                              onSort: (columnIndex, ascending) {
                                sortData(columnIndex, ascending);
                              },
                            ),
                            const DataColumn(
                              label: Text(
                                "تاريخ الخروج",
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
                                "نوع المركبة",
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
                          rows: citizens.map((citizen) {
                            return DataRow(
                              color:
                                  WidgetStateProperty.all(Colors.transparent),
                              cells: [
                                DataCell(SelectableText(citizen.id.toString(),
                                    maxLines: 5)),
                                DataCell(SelectableText(citizen.firstName,
                                    maxLines: 5)),
                                DataCell(SelectableText(citizen.lastName,
                                    maxLines: 5)),
                                DataCell(SelectableText(citizen.fonction,
                                    maxLines: 5)),
                                DataCell(SelectableText(
                                    formatDate(citizen.exitDate),
                                    maxLines: 5)),
                                DataCell(SelectableText(citizen.msgRef,
                                    maxLines: 5)),
                                DataCell(SelectableText(citizen.vehicleType,
                                    maxLines: 5)),
                                DataCell(
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                            Icons.remove_red_eye_outlined),
                                        onPressed: () =>
                                            viewCitizen(citizen, context),
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
                            backgroundColor: WidgetStatePropertyAll(
                                Color.fromARGB(255, 7, 80, 122))),
                        onPressed: () async {
                          if (citizens.isNotEmpty) {
                            await _printDataTable(
                                citizens); // Pass employees list here
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

Future<void> _printDataTable(List<Citizen> citizens) async {
  final pdf = pw.Document();
  final arabicFont = await _loadFont('assets/fonts/Cairo-Regular.ttf');

  final headers = [
    'المرجع',
    'المركبة',
    'جواز السفر',
    'المضيف',
    'تاريخ الوصول',
    'الجنسية',
    'اللقب',
    'الإسم',
    'رقم',
  ];

  // Convert tourists data to rows
  final dataRows = citizens.map((citizen) {
    return [
      citizen.msgRef,
      citizen.vehicleType,
      citizen.passportNumber,
      citizen.address,
      formatDate(citizen.exitDate),
      citizen.fonction,
      citizen.lastName,
      citizen.firstName,
      citizen.id.toString(),
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
