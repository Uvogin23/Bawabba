import 'dart:convert';
import 'package:bawabba/core/models/non_resident.dart';
import 'package:bawabba/core/models/tourist.dart';
import 'package:bawabba/core/services/config.dart';
import 'package:bawabba/ui/widgets/non_residents/edit_dialogue.dart';
import 'package:bawabba/ui/widgets/non_residents/show_info.dart';
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

Future<List<NonResident>> fetchCurrentNonResidents() async {
  final response = await http
      .get(Uri.parse('${Config.baseUrl}/api/non_residents/still_in_city'));

  if (response.statusCode == 200) {
    try {
      List<dynamic> data = json.decode(response.body);

      List<NonResident> list =
          data.map<NonResident>((item) => NonResident.fromJson(item)).toList();

      return list;
    } catch (e) {
      print('Error parsing non_residents: $e');
      rethrow; // Re-throw the exception for handling elsewhere
    }
  } else {
    throw Exception('Failed to load non_residents: ${response.body}');
  }
}

class NonResidentTable1 extends StatefulWidget {
  const NonResidentTable1({Key? key}) : super(key: key);

  @override
  State<NonResidentTable1> createState() => _NonResidentTable1();
}

class _NonResidentTable1 extends State<NonResidentTable1> {
  late Future<List<NonResident>> nonResidentsFuture;
  late List<NonResident> nonResidents;
  bool isAscending = true;
  int? sortColumnIndex;
  final _formKey = GlobalKey<FormState>();

  List<int> selectedNonResidentsIds = [];

  void _clearForm() {
    _formKey.currentState?.reset(); // Reset the form state

    setState(() {
      // Clear the dropdown selection
    });
  }

  Future<void> deleteNonResidentsAPI(int id) async {
    final url = Uri.parse('${Config.baseUrl}/api/non_residents/Delete/$id');

    final response = await http.delete(url);
    if (response.statusCode == 200) {
      setState(() {
        nonResidents.removeWhere((nonResident) => nonResident.id == id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم حذف الرعية بنجاح')),
        );
        // Call the success callback
        Navigator.pop(context);
      });
    }

    if (response.statusCode != 200) {
      throw Exception('خلل أثناء محاولة حذف الرعية: ${response.body}');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nonResidentsFuture = fetchCurrentNonResidents();
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
        nonResidents.sort((a, b) => ascending
            ? a.purposeOfVisit.compareTo(b.purposeOfVisit)
            : b.purposeOfVisit.compareTo(a.purposeOfVisit));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context, listen: false).user;
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
          final containerHeight = nonResidents.length < 7 ? 500.0 : 800.0;
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
                        'الرعايا المتواجدون بإقليم الولاية ',
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
                        columnSpacing: 35.0,
                        headingRowHeight: 40.0,
                        headingRowColor: WidgetStateProperty.resolveWith(
                            (states) =>
                                const Color.fromARGB(255, 233, 191, 24)),
                        sortColumnIndex: sortColumnIndex,
                        sortAscending: isAscending,
                        columns: [
                          DataColumn(
                            label: const Text(""),
                          ),
                          DataColumn(
                            label: const Text("الرقم"),
                            onSort: (columnIndex, ascending) {
                              sortData(columnIndex, ascending);
                            },
                          ),
                          DataColumn(
                            label: const Text("الإسم"),
                            onSort: (columnIndex, ascending) {
                              sortData(columnIndex, ascending);
                            },
                          ),
                          DataColumn(
                            label: const Text("اللقب"),
                            onSort: (columnIndex, ascending) {
                              sortData(columnIndex, ascending);
                            },
                          ),
                          DataColumn(
                            label: const Text(" الجنسية"),
                            onSort: (columnIndex, ascending) {
                              sortData(columnIndex, ascending);
                            },
                          ),
                          const DataColumn(
                            label: Text("تاريخ الوصول"),
                          ),
                          const DataColumn(
                            label: Text("يغادر يوم"),
                          ),
                          DataColumn(
                            label: const Text("المرجع"),
                            onSort: (columnIndex, ascending) {
                              sortData(columnIndex, ascending);
                            },
                          ),
                          const DataColumn(
                            label: Text(""),
                          ),
                        ],
                        rows: nonResidents.map((nonResident) {
                          return DataRow(
                            color: WidgetStateProperty.all(Colors.transparent),
                            cells: [
                              DataCell(
                                IconButton(
                                  icon: Icon(
                                    selectedNonResidentsIds
                                            .contains(nonResident.id)
                                        ? Icons.check_box
                                        : Icons.check_box_outline_blank,
                                    color: selectedNonResidentsIds
                                            .contains(nonResident.id)
                                        ? const Color.fromARGB(
                                            255, 212, 218, 141)
                                        : Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      if (selectedNonResidentsIds
                                          .contains(nonResident.id)) {
                                        // Deselect the tourist
                                        selectedNonResidentsIds
                                            .remove(nonResident.id);
                                      } else {
                                        // Select the tourist
                                        selectedNonResidentsIds
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
                              DataCell(
                                  SelectableText(nonResident.id.toString())),
                              DataCell(SelectableText(nonResident.firstName)),
                              DataCell(SelectableText(nonResident.lastName)),
                              DataCell(SelectableText(nonResident.nationality)),
                              DataCell(SelectableText(
                                  formatDate(nonResident.arrivalDate))),
                              DataCell(SelectableText(formatDate(
                                  nonResident.expectedDepartureDate))),
                              DataCell(SelectableText(nonResident.msgRef)),
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
                                    user?.role == 'operator'
                                        ? IconButton(
                                            icon: const Icon(Icons.delete),
                                            onPressed: () {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content:
                                                        Text('عملية ممنوعة')),
                                              );
                                            })
                                        : IconButton(
                                            icon: const Icon(Icons.delete),
                                            onPressed: () {
                                              showDeleteNonResidentDialog(
                                                  context, nonResident.id);
                                            }),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      )),
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
                          if (selectedNonResidentsIds.isNotEmpty) {
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
                        child: const Text('مغادرة '),
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

  void showDeleteNonResidentDialog(BuildContext context, int nonResidentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "تأكيد الحذف",
            textAlign: TextAlign.center,
          ),
          content: const Text(
            "هل أنت متأكد من حذف الرعية ؟ لا يمكن إلغاء الحذف بعد تأكيده",
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("إلغاء"),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await deleteNonResidentsAPI(nonResidentId);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('خلل أثناء محاولة حذف الرعية: $e')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color.fromARGB(255, 239, 214, 212), // Red for delete
              ),
              child: const Text(
                "حذف",
                style: TextStyle(),
              ),
            ),
          ],
        );
      },
    );
  }

  void logDepDialog(
    BuildContext context,
  ) {
    final _formKey = GlobalKey<FormState>();

    final expectedDepartureDateController = TextEditingController();
    final departureFlightInfoController = TextEditingController();
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
                    departureFlightInfoController,
                    "معلومات المغادرة",
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
                    if (departureFlightInfoController.text.isNotEmpty)
                      'departure_flight_info':
                          departureFlightInfoController.text,
                  };

                  try {
                    //await updateTouristAPI(touristId, updatedData);

                    for (int i = 0; i < selectedNonResidentsIds.length; i++) {
                      final updatedData = {
                        'tourist_id': selectedNonResidentsIds.elementAt(i),
                        if (expectedDepartureDateController.text.isNotEmpty)
                          'departure_time':
                              expectedDepartureDateController.text,
                        if (departureFlightInfoController.text.isNotEmpty)
                          'departure_method':
                              departureFlightInfoController.text,
                        if (msgRefController.text.isNotEmpty)
                          'dep_msg_ref': msgRefController.text,
                      };

                      addNonResidentsLog(updatedData);
                      updateTouristAPI(
                          selectedNonResidentsIds.elementAt(i), updatedData2);
                    }
                    setState(() {
                      nonResidents.removeWhere((tourist) =>
                          selectedNonResidentsIds.contains(tourist.id));
                      selectedNonResidentsIds = [];
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

Future<void> _printDataTable(List<NonResident> tourists) async {
  final pdf = pw.Document();
  final arabicFont = await _loadFont('assets/fonts/Cairo-Regular.ttf');

  final headers = [
    'المرجع',
    'تاريخ المغادرة',
    'المضيف',
    'جواز السفر',
    'الغرض من الزيارة',
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
      tourist.host,
      tourist.passportNumber,
      tourist.purposeOfVisit,
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
