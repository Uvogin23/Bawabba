import 'dart:convert';
import 'package:bawabba/core/models/citizen.dart';
import 'package:bawabba/core/services/auth_provider.dart';
import 'package:bawabba/core/services/config.dart';
import 'package:bawabba/ui/widgets/citizens/by_month_table.dart';
import 'package:bawabba/ui/widgets/citizens/citizens_history.dart';
import 'package:bawabba/ui/widgets/citizens/citizens_history_all.dart';
import 'package:bawabba/ui/widgets/citizens/show_info.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

class CitizensActions extends StatefulWidget {
  const CitizensActions({Key? key}) : super(key: key);

  @override
  State<CitizensActions> createState() => _CitizensActions();
}

class _CitizensActions extends State<CitizensActions> {
  late List<Citizen> citizens;
  bool isAscending = true;
  int? sortColumnIndex;
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final TextEditingController _filterfirstNameController =
      TextEditingController();
  final TextEditingController _filterlastNameController =
      TextEditingController();
  final TextEditingController _filterPlaceOfBirthController =
      TextEditingController();
  final TextEditingController _filterPasseportController =
      TextEditingController();
  final TextEditingController _filterVehicleTypeController =
      TextEditingController();
  final TextEditingController _filtermsgRefController = TextEditingController();
  final _filterExitdatestartController = TextEditingController();
  final _filterExitdateendController = TextEditingController();
  final _yearController = TextEditingController();
  Map<int, bool> selectedItems = {};
  List<int> selectedTouristIds = [];

  void _clearForm() {
    _formKey.currentState?.reset(); // Reset the form state
    // Clear the name field
    _filterfirstNameController.clear();
    _filterlastNameController.clear();
    _filterPlaceOfBirthController.clear();
    _filterPasseportController.clear();
    _filterVehicleTypeController.clear();
    _filtermsgRefController.clear();
    _filterExitdatestartController.clear();
    _filterExitdateendController.clear();

    setState(() {
      // Clear the dropdown selection
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    citizens = [];
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 10, 20, 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.grey[200],
        ),
      ),
    ));
  }

  Widget _buildDatePickerField(TextEditingController controller, String label) {
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 10, 20, 16),
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
    ));
  }

  Future<void> fetchFilteredCitizens(
      BuildContext context, Map<String, dynamic> updatedData) async {
    final url = Uri.parse('${Config.baseUrl}/api/citizens/filter');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updatedData),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);

        // Map the response data to a list of Tourist objects
        List<Citizen> list =
            data.map<Citizen>((item) => Citizen.fromJson(item)).toList();
        citizens = list;
        // Show a dialog based on the results
        _showSearchResultsDialog(context, citizens);
      } else {
        throw Exception('Failed to load non_residents: ${response.body}');
      }
    } catch (e) {
      _showErrorDialog(context, "حدث خطأ أثناء محاولة تحميل النتائج.$e");
    }
  }

// Helper function to show the search results dialog
  void _showSearchResultsDialog(BuildContext context, List<Citizen> tourists) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "نتائج البحث",
            textAlign: TextAlign.center,
          ),
          content: tourists.isEmpty
              ? const Center(
                  child: Text(
                    "لا توجد حركة تطابق معايير البحث",
                    textAlign: TextAlign.center,
                  ),
                )
              : SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: 40.0,
                      headingRowHeight: 40.0,
                      headingRowColor: WidgetStateProperty.resolveWith(
                          (states) => const Color.fromARGB(255, 144, 194, 230)),
                      sortColumnIndex: sortColumnIndex,
                      sortAscending: isAscending,
                      columns: const [
                        DataColumn(
                          label: Text("الرقم"),
                        ),
                        DataColumn(
                          label: Text("الإسم"),
                        ),
                        DataColumn(
                          label: Text("اللقب"),
                        ),
                        DataColumn(
                          label: Text(" الوظيفة"),
                        ),
                        DataColumn(
                          label: Text("تاريخ المغادرة"),
                        ),
                        DataColumn(
                          label: Text("المرجع"),
                        ),
                        DataColumn(
                          label: Text("نوع المركبة"),
                        ),
                        DataColumn(
                          label: Text(""),
                        ),
                      ],
                      rows: citizens.map((citizen) {
                        return DataRow(
                          color: WidgetStateProperty.all(Colors.transparent),
                          cells: [
                            DataCell(SelectableText(citizen.id.toString(),
                                maxLines: 5)),
                            DataCell(
                                SelectableText(citizen.firstName, maxLines: 5)),
                            DataCell(
                                SelectableText(citizen.lastName, maxLines: 5)),
                            DataCell(
                                SelectableText(citizen.fonction, maxLines: 5)),
                            DataCell(SelectableText(
                                formatDate(citizen.exitDate),
                                maxLines: 5)),
                            DataCell(
                                SelectableText(citizen.msgRef, maxLines: 5)),
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
                  )),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("إلغاء"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (citizens.isNotEmpty) {
                  await _printDataTable(citizens); // Pass employees list here
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("لا توجد بيانات للطباعة")),
                  );
                }
              },
              child: const Text('طباعة الجدول'),
            ),
          ],
        );
      },
    );
  }

// Helper function to show error dialogs
  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "خطأ",
            textAlign: TextAlign.center,
          ),
          content: Center(
            child: Text(
              message,
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //final user = Provider.of<AuthProvider>(context, listen: false).user;
    final screenWidth = MediaQuery.of(context).size.width;
    final sideMenu = Provider.of<AuthProvider>(context, listen: true).sideMenu;
    return Container(
      width: sideMenu ? screenWidth * 0.775 : screenWidth * 0.93,
      height: 460,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.fromLTRB(15, 2, 15, 2),
              width: sideMenu ? screenWidth * 0.385 : screenWidth * 0.46,
              height: 450,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: const BorderRadius.all(
                  Radius.circular(5),
                ),
                border: Border.all(
                    color: Color.fromARGB(255, 76, 77, 78), width: 1),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                      padding: EdgeInsets.only(
                        top: 25,
                        right: 40,
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search,
                              size: 30,
                              color: Color.fromARGB(255, 225, 180, 32)),
                          Text(
                            " بحث بإستعمال معايير محددة  ",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontFamily: 'Times New Roman',
                                fontSize: 20,
                                letterSpacing:
                                    0 /*percentages not used in flutter. defaulting to zero*/,
                                fontWeight: FontWeight.bold,
                                height: 1),
                          ),
                        ],
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildTextField(
                                _filterfirstNameController,
                                "الإسم",
                              ),
                              _buildTextField(
                                _filterlastNameController,
                                "اللقب",
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildTextField(
                                _filterVehicleTypeController,
                                "نوع المركبة",
                              ),
                              _buildTextField(
                                _filterPlaceOfBirthController,
                                "مكان الميلاد",
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildTextField(
                                _filterPasseportController,
                                "رقم جواز السفر",
                              ),
                              _buildTextField(
                                _filtermsgRefController,
                                "المرجع",
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildDatePickerField(
                                _filterExitdatestartController,
                                "تاريخ الدخول من",
                              ),
                              _buildDatePickerField(
                                _filterExitdateendController,
                                "إلى",
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _clearForm, // Call the clear function
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 240, 244, 245),
                          elevation: 5,
                        ),
                        child: const Text("مسح الإستمارة"),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          final updatedData2 = {
                            if (_filterfirstNameController.text.isNotEmpty)
                              'first_name': _filterfirstNameController.text,
                            if (_filterlastNameController.text.isNotEmpty)
                              'last_name': _filterlastNameController.text,
                            if (_filterExitdatestartController.text.isNotEmpty)
                              'exit_date_start':
                                  _filterExitdatestartController.text,
                            if (_filterExitdateendController.text.isNotEmpty)
                              'exit_date_end':
                                  _filterExitdateendController.text,
                            if (_filterVehicleTypeController.text.isNotEmpty)
                              'vehicle_type': _filterVehicleTypeController.text,
                            if (_filterPlaceOfBirthController.text.isNotEmpty)
                              'place_of_birth':
                                  _filterPlaceOfBirthController.text,
                            if (_filterPasseportController.text.isNotEmpty)
                              'passport_number':
                                  _filterPasseportController.text,
                            if (_filtermsgRefController.text.isNotEmpty)
                              'msg_ref': _filtermsgRefController.text,
                          };

                          if (updatedData2.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('يجب ملأ خانة واحدة على الأقل.'),
                              ),
                            );
                            return;
                          }

                          if ((_filterExitdatestartController.text.isEmpty &&
                                  _filterExitdatestartController
                                      .text.isNotEmpty) ||
                              (_filterExitdateendController.text.isNotEmpty &&
                                  _filterExitdateendController.text.isEmpty)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('يجب ملأ النطاق الزمني للوصول'),
                              ),
                            );
                            return;
                          }

                          try {
                            fetchFilteredCitizens(context, updatedData2);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('خلل بتحديث المعلومات: $e')),
                            );
                          }
                        },
                        style: const ButtonStyle(
                            elevation: WidgetStatePropertyAll(5),
                            backgroundColor:
                                WidgetStatePropertyAll(Config.colorPrimary)),
                        child: const Text(
                          "بحث عن حركة",
                          style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.fromLTRB(15, 2, 15, 2),
              width: sideMenu ? screenWidth * 0.385 : screenWidth * 0.46,
              height: 450,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(15, 2, 5, 2),
                    width: sideMenu ? screenWidth * 0.385 : screenWidth * 0.46,
                    height: 190,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(5),
                      ),
                      border: Border.all(
                          color: Color.fromARGB(255, 76, 77, 78), width: 1),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 12, right: 30),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_month,
                                  size: 30,
                                  color: Color.fromARGB(255, 225, 180, 32)),
                              Expanded(
                                child: Text(
                                  " توزيع عدد الرعايا حسب أشهر السنة  ",
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontFamily: 'Times New Roman',
                                      fontSize: 18,
                                      letterSpacing:
                                          0 /*percentages not used in flutter. defaulting to zero*/,
                                      fontWeight: FontWeight.bold,
                                      height: 1),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: Form(
                            key: _formKey2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Text field for year input
                                Expanded(
                                    child: Padding(
                                  padding: EdgeInsets.only(right: 5),
                                  child: TextFormField(
                                    controller: _yearController,
                                    keyboardType: TextInputType.number,
                                    maxLength: 4, // Limit input to 4 digits
                                    decoration: const InputDecoration(
                                      labelText: 'السنة',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                      ),
                                      counterText:
                                          '', // Hide the character counter
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'يرجى إدخال السنة';
                                      }
                                      final year = int.tryParse(value);
                                      if (year == null ||
                                          (year < 2023 || year > 2100)) {
                                        return 'يرجى إدخال سنة صحيحة';
                                      }
                                      return null;
                                    },
                                  ),
                                )),
                                const SizedBox(width: 30),
                                ElevatedButton(
                                  onPressed: () {
                                    _yearController.clear();
                                    _formKey2.currentState?.reset();
                                  }, // Call the clear function
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                        255, 240, 244, 245),
                                    elevation: 5,
                                  ),
                                  child: const Text("مسح "),
                                ), // Space between input and button
                                const SizedBox(width: 15),
                                Padding(
                                    padding: EdgeInsets.only(left: 5),
                                    child: ElevatedButton(
                                      style: const ButtonStyle(
                                          elevation: WidgetStatePropertyAll(5),
                                          backgroundColor:
                                              WidgetStatePropertyAll(
                                                  Config.colorPrimary)),
                                      onPressed: () {
                                        if (_formKey2.currentState!
                                            .validate()) {
                                          // All validations passed
                                          final year = int.tryParse(
                                              _yearController.text);
                                          showCitizensByMonth(context, year!);
                                        }
                                      },
                                      child: const Text(
                                        'بحث',
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 255, 255, 255)),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(15, 2, 5, 2),
                    width: sideMenu ? screenWidth * 0.385 : screenWidth * 0.46,
                    height: 190,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(5),
                      ),
                      border: Border.all(
                          color: Color.fromARGB(255, 76, 77, 78), width: 1),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 20, right: 30),
                          child: Row(
                            children: [
                              Icon(Icons.history,
                                  size: 30,
                                  color: Color.fromARGB(255, 225, 180, 32)),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                  child: Text(
                                "قائمة الحركات المسجلة",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontFamily: 'Times New Roman',
                                    fontSize: 18,
                                    letterSpacing:
                                        0 /*percentages not used in flutter. defaulting to zero*/,
                                    fontWeight: FontWeight.bold,
                                    height: 1),
                              )),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Padding(
                            padding: EdgeInsets.only(right: 10, left: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    style: const ButtonStyle(
                                        elevation: WidgetStatePropertyAll(5),
                                        backgroundColor: WidgetStatePropertyAll(
                                            Color.fromARGB(255, 166, 149, 24))),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return const CHistoryTable2();
                                        },
                                      );
                                    },
                                    child: const Text(
                                      '  القائمة الكاملة  ',
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255)),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 50,
                                ),
                                Expanded(
                                  child: ElevatedButton(
                                    style: const ButtonStyle(
                                        elevation: WidgetStatePropertyAll(5),
                                        backgroundColor: WidgetStatePropertyAll(
                                            Config.colorPrimary)),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return const CHistoryTable();
                                        },
                                      );
                                    },
                                    child: const Text(
                                      'الرعايا المغادرين',
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255)),
                                    ),
                                  ),
                                )
                              ],
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
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
