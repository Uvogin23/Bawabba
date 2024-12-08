import 'dart:convert';
import 'package:bawabba/core/models/tourist.dart';
import 'package:bawabba/ui/widgets/tourists/add_tourist_form.dart';
import 'package:bawabba/ui/widgets/tourists/by_month_table.dart';
import 'package:bawabba/ui/widgets/tourists/by_nationality_table.dart';
import 'package:bawabba/ui/widgets/tourists/edit_dialogue.dart';
import 'package:bawabba/ui/widgets/tourists/show_info.dart';
import 'package:bawabba/ui/widgets/tourists/tourist_history.dart';
import 'package:bawabba/ui/widgets/tourists/tourist_history_all.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bawabba/main.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class TouristsActions extends StatefulWidget {
  const TouristsActions({Key? key}) : super(key: key);

  @override
  State<TouristsActions> createState() => _TouristsActions();
}

class _TouristsActions extends State<TouristsActions> {
  late Future<List<Tourist>> touristsFuture;
  late List<Tourist> tourists;
  bool isAscending = true;
  int? sortColumnIndex;
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final TextEditingController _filterfirstNameController =
      TextEditingController();
  final TextEditingController _filterlastNameController =
      TextEditingController();
  final TextEditingController _filterreceivingAgencyController =
      TextEditingController();
  final TextEditingController _filterarrivalFlightInfoController =
      TextEditingController();
  final TextEditingController _filternationalityController =
      TextEditingController();
  final TextEditingController _filtermsgRefController = TextEditingController();
  final _filterarrivalDateStartController = TextEditingController();
  final _filterarrivalDateEndController = TextEditingController();
  final _yearController = TextEditingController();
  Map<int, bool> selectedItems = {};
  List<int> selectedTouristIds = [];
  Nationality? selectedNationality;

  void _clearForm() {
    _formKey.currentState?.reset(); // Reset the form state
    // Clear the name field
    _filterfirstNameController.clear();
    _filterlastNameController.clear();
    _filterreceivingAgencyController.clear();
    _filterarrivalFlightInfoController.clear();
    _filternationalityController.clear();
    _filtermsgRefController.clear();
    _filterarrivalDateStartController.clear();
    _filterarrivalDateEndController.clear();

    setState(() {
      selectedNationality = null;
      // Clear the dropdown selection
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 10, 20, 16),
      child: SizedBox(
        height: 50,
        width: 200,
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: Colors.grey[200],
          ),
        ),
      ),
    );
  }

  Widget _buildDatePickerField(TextEditingController controller, String label) {
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    return Padding(
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
            child: SizedBox(
          height: 50,
          width: 200,
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
        )),
      ),
    );
  }

  Future<void> fetchFilteredTourists(
      BuildContext context, Map<String, dynamic> updatedData) async {
    final url = Uri.parse('http://127.0.0.1:5000/api/tourists/filter');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updatedData),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);

        // Map the response data to a list of Tourist objects
        List<Tourist> list =
            data.map<Tourist>((item) => Tourist.fromJson(item)).toList();
        tourists = list;
        // Show a dialog based on the results
        _showSearchResultsDialog(context, tourists);
      } else {
        throw Exception('Failed to load tourists: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorDialog(context, "حدث خطأ أثناء محاولة تحميل النتائج.$e");
    }
  }

// Helper function to show the search results dialog
  void _showSearchResultsDialog(BuildContext context, List<Tourist> tourists) {
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
                    "لا يوجد سياح يطابقون معايير البحث",
                    textAlign: TextAlign.center,
                  ),
                )
              : SingleChildScrollView(
                  scrollDirection: Axis.vertical,
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
                        label: Text(" الجنسية"),
                      ),
                      DataColumn(
                        label: Text("تاريخ الوصول"),
                      ),
                      DataColumn(
                        label: Text("يغادر يوم"),
                      ),
                      DataColumn(
                        label: Text("المرجع"),
                      ),
                      DataColumn(
                        label: Text("الوكالة السياحية"),
                      ),
                      DataColumn(
                        label: Text(""),
                      ),
                    ],
                    rows: tourists.map((tourist) {
                      return DataRow(
                        color: WidgetStateProperty.all(Colors.transparent),
                        cells: [
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
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("إلغاء"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (tourists.isNotEmpty) {
                  await _printDataTable(tourists); // Pass employees list here
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

    return Container(
      width: screenWidth * 0.775,
      height: 460,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.fromLTRB(15, 2, 15, 2),
              width: screenWidth * 0.385,
              height: 450,
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(15),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 144, 140, 140)
                          .withOpacity(0.5),
                      offset: const Offset(
                          4, 4), // Horizontal and vertical shadow displacement
                      blurRadius: 8.0, // Soft edges of the shadow
                      spreadRadius: 2.0, // Expands the shadow
                    ),
                  ]),
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
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16.0, 10, 20, 16),
                                child: SizedBox(
                                  height: 50,
                                  width: 200,
                                  child: DropdownButtonFormField<Nationality>(
                                    isExpanded: false,
                                    isDense: true,
                                    decoration: InputDecoration(
                                      labelText: 'الجنسية',
                                      border: const OutlineInputBorder(),
                                      filled: true,
                                      fillColor: Colors.grey[200],
                                    ),
                                    value: selectedNationality,
                                    onChanged: (Nationality? newValue) {
                                      setState(() {
                                        selectedNationality = newValue;
                                      });
                                    },
                                    items: Nationality.values
                                        .map((Nationality role) {
                                      return DropdownMenuItem<Nationality>(
                                          value: role, child: Text(role.name));
                                    }).toList(),
                                  ),
                                ),
                              ),
                              _buildTextField(
                                _filterreceivingAgencyController,
                                "الوكالة السياحية",
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildTextField(
                                _filterarrivalFlightInfoController,
                                "معلومات الوصول",
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
                                _filterarrivalDateStartController,
                                "تاريخ الدخول من",
                              ),
                              _buildDatePickerField(
                                _filterarrivalDateEndController,
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
                            if (_filterreceivingAgencyController
                                .text.isNotEmpty)
                              'receiving_agency':
                                  _filterreceivingAgencyController.text,
                            if (_filterarrivalFlightInfoController
                                .text.isNotEmpty)
                              'arrival_flight_info':
                                  _filterarrivalFlightInfoController.text,
                            if (_filterfirstNameController.text.isNotEmpty)
                              'first_name': _filterfirstNameController.text,
                            if (_filterlastNameController.text.isNotEmpty)
                              'last_name': _filterlastNameController.text,
                            if (_filterarrivalDateStartController
                                .text.isNotEmpty)
                              'arrival_date_start':
                                  _filterarrivalDateStartController.text,
                            if (_filterarrivalDateEndController.text.isNotEmpty)
                              'arrival_date_end':
                                  _filterarrivalDateEndController.text,
                            if (selectedNationality?.name != null)
                              'nationality': selectedNationality?.name,
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

                          if ((_filterarrivalDateStartController.text.isEmpty &&
                                  _filterarrivalDateEndController
                                      .text.isNotEmpty) ||
                              (_filterarrivalDateStartController
                                      .text.isNotEmpty &&
                                  _filterarrivalDateEndController
                                      .text.isEmpty)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('يجب ملأ النطاق الزمني للوصول'),
                              ),
                            );
                            return;
                          }

                          try {
                            fetchFilteredTourists(context, updatedData2);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('خلل بتحديث المعلومات: $e')),
                            );
                          }
                        },
                        style: const ButtonStyle(
                            elevation: WidgetStatePropertyAll(5),
                            backgroundColor: WidgetStatePropertyAll(
                                Color.fromARGB(255, 7, 80, 122))),
                        child: const Text(
                          "بحث عن سائح",
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
              width: screenWidth * 0.385,
              height: 450,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(15, 2, 5, 2),
                    width: screenWidth * 0.385,
                    height: 130,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(15),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 144, 140, 140)
                                .withOpacity(0.5),
                            offset: const Offset(4,
                                4), // Horizontal and vertical shadow displacement
                            blurRadius: 8.0, // Soft edges of the shadow
                            spreadRadius: 2.0, // Expands the shadow
                          ),
                        ]),
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
                              Text(
                                " توزيع عدد السياح حسب أشهر السنة  ",
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
                                SizedBox(
                                  width: 200, // Restrict width for better UX
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
                                ),
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
                                ElevatedButton(
                                  style: const ButtonStyle(
                                      elevation: WidgetStatePropertyAll(5),
                                      backgroundColor: WidgetStatePropertyAll(
                                          Color.fromARGB(255, 7, 80, 122))),
                                  onPressed: () {
                                    if (_formKey2.currentState!.validate()) {
                                      // All validations passed
                                      final year =
                                          int.tryParse(_yearController.text);
                                      showTouristsByMonth(context, year!);
                                    }
                                  },
                                  child: const Text(
                                    'بحث',
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(15, 2, 5, 2),
                    width: screenWidth * 0.385,
                    height: 130,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(15),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 144, 140, 140)
                                .withOpacity(0.5),
                            offset: const Offset(4,
                                4), // Horizontal and vertical shadow displacement
                            blurRadius: 8.0, // Soft edges of the shadow
                            spreadRadius: 2.0, // Expands the shadow
                          ),
                        ]),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 20, right: 30),
                          child: Row(
                            children: [
                              Icon(Icons.flag_circle,
                                  size: 30,
                                  color: Color.fromARGB(255, 225, 180, 32)),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "عدد السياح الأجانب المسجلين بالتطبيقة حسب الجنسية",
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
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Center(
                          child: ElevatedButton(
                            style: const ButtonStyle(
                                elevation: WidgetStatePropertyAll(5),
                                backgroundColor: WidgetStatePropertyAll(
                                    Color.fromARGB(255, 7, 80, 122))),
                            onPressed: () {
                              showTouristsByNationality(context);
                            },
                            child: const Text(
                              'إظهار النتائج',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255)),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(15, 2, 5, 2),
                    width: screenWidth * 0.385,
                    height: 130,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(15),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 144, 140, 140)
                                .withOpacity(0.5),
                            offset: const Offset(4,
                                4), // Horizontal and vertical shadow displacement
                            blurRadius: 8.0, // Soft edges of the shadow
                            spreadRadius: 2.0, // Expands the shadow
                          ),
                        ]),
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
                              Text(
                                "قائمة السياح الأجانب المسجلين بالتطبيقة",
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
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: const ButtonStyle(
                                  elevation: WidgetStatePropertyAll(5),
                                  backgroundColor: WidgetStatePropertyAll(
                                      Color.fromARGB(255, 166, 149, 24))),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return HistoryTable2();
                                  },
                                );
                              },
                              child: const Text(
                                '  القائمة الكاملة  ',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255)),
                              ),
                            ),
                            const SizedBox(
                              width: 50,
                            ),
                            ElevatedButton(
                              style: const ButtonStyle(
                                  elevation: WidgetStatePropertyAll(5),
                                  backgroundColor: WidgetStatePropertyAll(
                                      Color.fromARGB(255, 7, 80, 122))),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return HistoryTable();
                                  },
                                );
                              },
                              child: const Text(
                                'السياح المغادرين',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255)),
                              ),
                            ),
                          ],
                        ),
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
