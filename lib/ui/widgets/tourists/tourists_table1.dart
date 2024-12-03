import 'dart:convert';
import 'package:bawabba/core/models/tourist.dart';
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

Future<List<Tourist>> fetchCurrentTourists() async {
  final response = await http
      .get(Uri.parse('http://127.0.0.1:5000/api/tourists/still_in_city'));

  if (response.statusCode == 200) {
    try {
      List<dynamic> data = json.decode(response.body);

      List<Tourist> list =
          data.map<Tourist>((item) => Tourist.fromJson(item)).toList();

      return list;
    } catch (e) {
      print('Error parsing tourists: $e');
      rethrow; // Re-throw the exception for handling elsewhere
    }
  } else {
    throw Exception('Failed to load diplomats: ${response.statusCode}');
  }
}

class TouristTable1 extends StatefulWidget {
  const TouristTable1({Key? key}) : super(key: key);

  @override
  State<TouristTable1> createState() => _TouristTable1();
}

class _TouristTable1 extends State<TouristTable1> {
  late Future<List<Tourist>> touristsFuture;
  late List<Tourist> tourists;
  bool isAscending = true;
  int? sortColumnIndex;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _placeOfBirthController = TextEditingController();
  final TextEditingController _passportNumberController =
      TextEditingController();

  final TextEditingController _receivingAgencyController =
      TextEditingController();
  final TextEditingController _circuitController = TextEditingController();
  final TextEditingController _arrivalFlightInfoController =
      TextEditingController();
  final TextEditingController _departureFlightInfoController =
      TextEditingController();
  final TextEditingController _touristicGuideController =
      TextEditingController();
  final TextEditingController _msgRefController = TextEditingController();
  Map<int, bool> selectedItems = {};
  List<int> selectedTouristIds = [];

  void _clearForm() {
    _formKey.currentState?.reset(); // Reset the form state
    _placeOfBirthController.clear(); // Clear the name field
    _firstNameController.clear();
    _lastNameController.clear();
    _passportNumberController.clear();
    _receivingAgencyController.clear();
    _circuitController.clear();
    _arrivalFlightInfoController.clear();
    _departureFlightInfoController.clear();
    _touristicGuideController.clear();
    _msgRefController.clear();

    setState(() {
      // Clear the dropdown selection
    });
  }

  Future<void> deleteTouristAPI(int id) async {
    final url = Uri.parse('http://127.0.0.1:5000/api/tourists/Delete/$id');

    final response = await http.delete(url);
    if (response.statusCode == 200) {
      setState(() {
        tourists.removeWhere((tourist) => tourist.id == id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم حذف السائح بنجاح')),
        );
        // Call the success callback
        Navigator.pop(context);
      });
    }

    if (response.statusCode != 200) {
      throw Exception('خلل أثناء محاولة حذف السائح: ${response.body}');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    touristsFuture = fetchCurrentTourists();
  }

  void sortData(int columnIndex, bool ascending) {
    setState(() {
      isAscending = ascending;
      sortColumnIndex = columnIndex;
      if (columnIndex == 1) {
        tourists.sort(
            (a, b) => ascending ? a.id.compareTo(b.id) : b.id.compareTo(a.id));
      } else if (columnIndex == 2) {
        tourists.sort((a, b) => ascending
            ? a.firstName.compareTo(b.firstName)
            : b.firstName.compareTo(a.firstName));
      } else if (columnIndex == 3) {
        tourists.sort((a, b) => ascending
            ? a.lastName.compareTo(b.lastName)
            : b.lastName.compareTo(a.lastName));
      } else if (columnIndex == 4) {
        tourists.sort((a, b) => ascending
            ? a.nationality.compareTo(b.nationality)
            : b.nationality.compareTo(a.nationality));
      } else if (columnIndex == 7) {
        tourists.sort((a, b) => ascending
            ? a.msgRef.compareTo(b.msgRef)
            : b.msgRef.compareTo(a.msgRef));
      } else if (columnIndex == 8) {
        tourists.sort((a, b) => ascending
            ? a.receivingAgency.compareTo(b.receivingAgency)
            : b.receivingAgency.compareTo(a.receivingAgency));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth * 0.775,
      height: 600,
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: const BorderRadius.all(
            Radius.circular(15),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 144, 140, 140).withOpacity(0.5),
              offset: const Offset(
                  4, 4), // Horizontal and vertical shadow displacement
              blurRadius: 8.0, // Soft edges of the shadow
              spreadRadius: 2.0, // Expands the shadow
            ),
          ]),
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
                  color: Color.fromARGB(255, 5, 5, 5),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  'السياح المتواجدون بإقليم الولاية ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color.fromARGB(255, 39, 39, 40),
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
          FutureBuilder<List<Tourist>>(
            future: touristsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("لا يوجد سياح بإقليم الولاية"));
              } else {
                tourists = snapshot.data!;
                return Expanded(
                    child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    columnSpacing: 35.0,
                    headingRowHeight: 40.0,
                    headingRowColor: WidgetStateProperty.resolveWith(
                        (states) => const Color.fromARGB(255, 212, 218, 141)),
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
                      DataColumn(
                        label: const Text("الوكالة السياحية"),
                        onSort: (columnIndex, ascending) {
                          sortData(columnIndex, ascending);
                        },
                      ),
                      const DataColumn(
                        label: Text(""),
                      ),
                    ],
                    rows: tourists.map((tourist) {
                      return DataRow(
                        color: WidgetStateProperty.all(Colors.transparent),
                        cells: [
                          DataCell(
                            IconButton(
                              icon: Icon(
                                selectedTouristIds.contains(tourist.id)
                                    ? Icons.check_box
                                    : Icons.check_box_outline_blank,
                                color: selectedTouristIds.contains(tourist.id)
                                    ? const Color.fromARGB(255, 212, 218, 141)
                                    : Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  if (selectedTouristIds.contains(tourist.id)) {
                                    // Deselect the tourist
                                    selectedTouristIds.remove(tourist.id);
                                  } else {
                                    // Select the tourist
                                    selectedTouristIds.add(tourist.id);
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
                          DataCell(SelectableText(tourist.id.toString())),
                          DataCell(SelectableText(tourist.firstName)),
                          DataCell(SelectableText(tourist.lastName)),
                          DataCell(SelectableText(tourist.nationality)),
                          DataCell(
                              SelectableText(formatDate(tourist.arrivalDate))),
                          DataCell(SelectableText(
                              formatDate(tourist.expectedDepartureDate))),
                          DataCell(SelectableText(tourist.msgRef)),
                          DataCell(SelectableText(tourist.receivingAgency)),
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  icon:
                                      const Icon(Icons.remove_red_eye_outlined),
                                  onPressed: () =>
                                      viewTourist(tourist, context),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => showUpdateTouristDialog(
                                      context, tourist.id),
                                ),
                                user?.role == 'operator'
                                    ? IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text('عملية ممنوعة')),
                                          );
                                        })
                                    : IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () {
                                          showDeleteTouristDialog(
                                              context, tourist.id);
                                        }),
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
                padding: const EdgeInsets.fromLTRB(8, 30, 8, 8),
                child: ElevatedButton(
                  onPressed: () async {
                    if (selectedTouristIds.isNotEmpty) {
                      logDepDialog(
                        context,
                      ); // Pass employees list here
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("يرجى إختيار السياح المغادرين")),
                      );
                    }
                  },
                  child: const Text('مغادرة '),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(100, 30, 8, 8),
                child: ElevatedButton(
                  onPressed: () async {
                    if (tourists.isNotEmpty) {
                      await _printDataTable(
                          tourists); // Pass employees list here
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("لا توجد بيانات للطباعة")),
                      );
                    }
                  },
                  child: const Text('طباعة الجدول'),
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

  void showDeleteTouristDialog(BuildContext context, int touristId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "تأكيد الحذف",
            textAlign: TextAlign.center,
          ),
          content: const Text(
            "هل أنت متأكد من حذف السائح ؟ لا يمكن إلغاء الحذف بعد تأكيده",
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
                  await deleteTouristAPI(touristId);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('خلل أثناء محاولة حذف السائح: $e')),
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

                    for (int i = 0; i < selectedTouristIds.length; i++) {
                      final updatedData = {
                        'tourist_id': selectedTouristIds.elementAt(i),
                        if (expectedDepartureDateController.text.isNotEmpty)
                          'departure_time':
                              expectedDepartureDateController.text,
                        if (departureFlightInfoController.text.isNotEmpty)
                          'departure_method':
                              departureFlightInfoController.text,
                        if (msgRefController.text.isNotEmpty)
                          'dep_msg_ref': msgRefController.text,
                      };
                      print(updatedData);
                      addTouristLog(updatedData);
                      updateTouristAPI(
                          selectedTouristIds.elementAt(i), updatedData2);
                    }
                    setState(() {
                      tourists.removeWhere(
                          (tourist) => selectedTouristIds.contains(tourist.id));
                      selectedTouristIds = [];
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

Future<void> addTouristLog(Map<String, dynamic> updatedData) async {
  final url = Uri.parse('http://127.0.0.1:5000/api/tourists/add_departure_log');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(updatedData),
  );

  if (response.statusCode != 201) {
    throw Exception('Failed to update tourist: ${response.body}');
  }
}
