import 'dart:convert';
import 'package:bawabba/core/models/non_resident.dart';
import 'package:bawabba/core/services/config.dart';
import 'package:bawabba/ui/widgets/non_residents/edit_dialogue.dart';
import 'package:bawabba/ui/widgets/non_residents/nonResidents_actions.dart';
import 'package:bawabba/ui/widgets/non_residents/show_info.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:bawabba/main.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

Future<List<NonResident>> fetchExpectedNonResidents() async {
  final response = await http
      .get(Uri.parse('${Config.baseUrl}/api/non_residents/supposed_to_leave'));

  if (response.statusCode == 200) {
    try {
      List<dynamic> data = json.decode(response.body);

      List<NonResident> list =
          data.map<NonResident>((item) => NonResident.fromJson(item)).toList();

      return list;
    } catch (e) {
      rethrow; // Re-throw the exception for handling elsewhere
    }
  } else {
    throw Exception('Failed to load non_residents: ${response.statusCode}');
  }
}

class NonResidentsTable2 extends StatefulWidget {
  const NonResidentsTable2({Key? key}) : super(key: key);

  @override
  State<NonResidentsTable2> createState() => _NonResidentsTable2();
}

class _NonResidentsTable2 extends State<NonResidentsTable2> {
  late Future<List<NonResident>> nonResidentsFuture;
  late List<NonResident> nonResidents;
  bool isAscending = true;
  int? sortColumnIndex;
  final _formKey = GlobalKey<FormState>();
  Map<int, bool> selectedItems = {};
  List<int> selectednonResidentIds = [];
  void _clearForm() {
    _formKey.currentState?.reset(); // Reset the form state
    setState(() {
      // Clear the dropdown selection
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nonResidentsFuture = fetchExpectedNonResidents();
    nonResidents = [];
  }

  void sortData(int columnIndex, bool ascending) {
    setState(() {
      isAscending = ascending;
      sortColumnIndex = columnIndex;
      if (columnIndex == 1) {
        nonResidents.sort(
            (a, b) => ascending ? a.id.compareTo(b.id) : b.id.compareTo(a.id));
      } else if (columnIndex == 2) {
        nonResidents.sort((a, b) => ascending
            ? a.firstName.compareTo(b.firstName)
            : b.firstName.compareTo(a.firstName));
      } else if (columnIndex == 3) {
        nonResidents.sort((a, b) => ascending
            ? a.lastName.compareTo(b.lastName)
            : b.lastName.compareTo(a.lastName));
      } else if (columnIndex == 4) {
        nonResidents.sort((a, b) => ascending
            ? a.nationality.compareTo(b.nationality)
            : b.nationality.compareTo(a.nationality));
      } else if (columnIndex == 7) {
        nonResidents.sort((a, b) => ascending
            ? a.msgRef.compareTo(b.msgRef)
            : b.msgRef.compareTo(a.msgRef));
      } else if (columnIndex == 8) {
        nonResidents.sort((a, b) =>
            ascending ? a.host.compareTo(b.host) : b.host.compareTo(a.host));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //final user = Provider.of<AuthProvider>(context, listen: false).user;
    final screenWidth = MediaQuery.of(context).size.width;

    return FutureBuilder<List<NonResident>>(
      future: nonResidentsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("لا يوجد رعايا بإقليم الولاية"));
        } else {
          nonResidents = snapshot.data!;
          final containerHeight = nonResidents.length < 7 ? 600.0 : 700.0;
          return Container(
            width: screenWidth * 0.775,
            height: containerHeight,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 255, 255),
              borderRadius: const BorderRadius.all(
                Radius.circular(5),
              ),
              border:
                  Border.all(color: Color.fromARGB(255, 76, 77, 78), width: 1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 30,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 30),
                      child: Icon(
                        Icons.list,
                        size: 30,
                        color: Color.fromARGB(255, 233, 191, 24),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text(
                        'قائمة الرعايا المغادرين ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontFamily: 'Times New Roman',
                            fontSize: 16,
                            letterSpacing:
                                0 /*percentages not used in flutter. defaulting to zero*/,
                            fontWeight: FontWeight.bold,
                            height: 1),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Expanded(
                    child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: 40.0,
                      headingRowHeight: 40.0,
                      headingRowColor: WidgetStateProperty.resolveWith(
                          (states) => Config.colorPrimary),
                      sortColumnIndex: sortColumnIndex,
                      sortAscending: isAscending,
                      columns: [
                        const DataColumn(
                          label: Text(
                            "",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
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
                        const DataColumn(
                          label: Text(
                            "",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                      rows: nonResidents.map((nonResident) {
                        return DataRow(
                          color: WidgetStateProperty.all(Colors.transparent),
                          cells: [
                            DataCell(
                              IconButton(
                                icon: Icon(
                                  selectednonResidentIds
                                          .contains(nonResident.id)
                                      ? Icons.check_box
                                      : Icons.check_box_outline_blank,
                                  color: selectednonResidentIds
                                          .contains(nonResident.id)
                                      ? const Color.fromARGB(255, 144, 194, 230)
                                      : Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (selectednonResidentIds
                                        .contains(nonResident.id)) {
                                      // Deselect the tourist
                                      selectednonResidentIds
                                          .remove(nonResident.id);
                                    } else {
                                      // Select the tourist
                                      selectednonResidentIds
                                          .add(nonResident.id);
                                    }
                                  });
                                  /*for (int i = 0;
                                    i < selectedTouristIds.length;
                                    i++) {
                                  print(selectedTouristIds);
                                }*/
                                },
                              ),
                            ),
                            DataCell(SelectableText(
                              nonResident.id.toString(),
                              maxLines: 5,
                            )),
                            DataCell(SelectableText(
                              nonResident.firstName,
                              maxLines: 5,
                            )),
                            DataCell(SelectableText(nonResident.lastName,
                                maxLines: 5)),
                            DataCell(SelectableText(nonResident.nationality,
                                maxLines: 5)),
                            DataCell(SelectableText(
                                formatDate(nonResident.arrivalDate),
                                maxLines: 5)),
                            DataCell(SelectableText(
                                formatDate(nonResident.expectedDepartureDate),
                                maxLines: 5)),
                            DataCell(SelectableText(nonResident.msgRef,
                                maxLines: 5)),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                        Icons.remove_red_eye_outlined),
                                    onPressed: () =>
                                        viewNonResident(nonResident, context),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () =>
                                        showUpdateNonResidentDialog(
                                            context, nonResident.id),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 30, 8, 8),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 240, 244, 245),
                          elevation: 5,
                        ),
                        onPressed: () async {
                          if (selectednonResidentIds.isNotEmpty) {
                            logDepDialog(
                              context,
                            ); // Pass employees list here
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text("يرجى إختيار الرعايا المغادرين")),
                            );
                          }
                        },
                        child: const Text(
                          'مغادرة ',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(100, 30, 8, 8),
                      child: ElevatedButton(
                        style: const ButtonStyle(
                            elevation: WidgetStatePropertyAll(5),
                            backgroundColor:
                                WidgetStatePropertyAll(Config.colorPrimary)),
                        onPressed: () async {
                          if (nonResidents.isNotEmpty) {
                            await _printDataTable(
                                nonResidents); // Pass employees list here
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
          );
        }
      },
    );
  }

  void logDepDialog(
    BuildContext context,
  ) {
    final _formKey = GlobalKey<FormState>();

    final expectedDepartureDateController = TextEditingController();
    final observationController = TextEditingController();
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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "يرجى إدخال $label";
                }
                return null;
              },
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
                  firstDate: DateTime.now().subtract(const Duration(days: 7)),
                  lastDate: DateTime.now().add(const Duration(days: 1)),
                );
                if (pickedDate != null) {
                  controller.text =
                      dateFormat.format(pickedDate); // Format as yyyy-MM-dd
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "يرجى إدخال $label"; // Validation message for empty input
                    }

                    // Check if the value entered is a valid date
                    try {
                      dateFormat.parseStrict(value); // Validate date format
                    } catch (e) {
                      return "التاريخ المدخل غير صحيح"; // Error message for invalid date format
                    }

                    return null; // Return null if validation passes
                  },
                ),
              ),
            ),
          );
        }

        return AlertDialog(
          title: const Text(
            "   المعلومات المتعلقة بالخروج",
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildDatePickerField(
                    expectedDepartureDateController,
                    "تاريخ المغادرة",
                  ),
                  _buildTextField(
                    observationController,
                    "ملاحظة",
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
                if (_formKey.currentState!.validate()) {
                  // All validations passed

                  final updatedData2 = {
                    if (expectedDepartureDateController.text.isNotEmpty)
                      'expected_departure_date':
                          expectedDepartureDateController.text,
                    if (observationController.text.isNotEmpty)
                      'observations': observationController.text,
                  };

                  try {
                    //await updateTouristAPI(touristId, updatedData);

                    for (int i = 0; i < selectednonResidentIds.length; i++) {
                      final updatedData = {
                        'non_resident_id': selectednonResidentIds.elementAt(i),
                        if (expectedDepartureDateController.text.isNotEmpty)
                          'departure_time':
                              expectedDepartureDateController.text,
                        if (observationController.text.isNotEmpty)
                          'observations': observationController.text,
                        if (msgRefController.text.isNotEmpty)
                          'dep_msg_ref': msgRefController.text,
                      };

                      addNonResidentsLog(updatedData);

                      updateNonResidentAPI(
                          selectednonResidentIds.elementAt(i), updatedData2);
                    }
                    setState(() {
                      nonResidents.removeWhere((tourist) =>
                          selectednonResidentIds.contains(tourist.id));
                      selectednonResidentIds = [];
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم تسجيل المغادرة')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('خلل بتحديث المعلومات: $e')),
                    );
                  }
                }
              },
              child: const Text("المغادرة"),
            ),
          ],
        );
      },
    );
  }
}

String formatDate(DateTime date) {
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  return formatter.format(date);
}

Future<void> _printDataTable(List<NonResident> nonResidents) async {
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
  final dataRows = nonResidents.map((nonResident) {
    return [
      nonResident.msgRef,
      formatDate(nonResident.expectedDepartureDate),
      nonResident.host,
      nonResident.passportNumber,
      nonResident.vehicleInformation,
      formatDate(nonResident.arrivalDate),
      nonResident.nationality,
      nonResident.lastName,
      nonResident.firstName,
      nonResident.id.toString(),
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

Future<void> addNonResidentsLog(Map<String, dynamic> updatedData) async {
  final url =
      Uri.parse('${Config.baseUrl}/api/non_residents/add_departure_log');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(updatedData),
  );

  if (response.statusCode != 201) {
    throw Exception('Failed to update non_residents: ${response.body}');
  }
}
