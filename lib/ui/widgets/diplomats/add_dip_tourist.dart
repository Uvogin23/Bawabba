import 'dart:convert';
import 'package:bawabba/core/models/tourist.dart';
import 'package:bawabba/core/services/config.dart';
import 'package:bawabba/ui/widgets/diplomats/add_diplomat_form.dart';
import 'package:bawabba/ui/widgets/tourists/edit_dialogue.dart';
import 'package:bawabba/ui/widgets/tourists/show_info.dart';
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

Future<List<Tourist>> fetchDiplomatsTourists(int id) async {
  final response =
      await http.get(Uri.parse('${Config.baseUrl}/api/diplomats/$id/tourists'));

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
    throw Exception('Failed to load diplomats: ${response.statusCode}');
  }
}

class AddDipTourist extends StatefulWidget {
  final int id;
  const AddDipTourist({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<AddDipTourist> createState() => _AddDipTourist();
}

class _AddDipTourist extends State<AddDipTourist> {
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

  DateTime? _dateOfBirth;
  DateTime? _passportExpiry;
  DateTime? _arrivalDate;
  DateTime? _expectedDepartureDate;
  Nationality? selectedNationality;

  bool _isLoading = false;

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
      _dateOfBirth = null;
      _passportExpiry = null;
      _arrivalDate = null;
      _expectedDepartureDate = null;
      selectedNationality = null;
      // Clear the dropdown selection
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //touristsFuture = fetchDiplomatsTourists(widget.id);
  }

  Future<void> _addtourist() async {
    setState(() {
      _isLoading = true;
    });
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    final url =
        Uri.parse('${Config.baseUrl}/api/tourists/Add'); // Your API endpoint
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "first_name": _firstNameController.text,
          "last_name": _lastNameController.text,
          "date_of_birth": dateFormat.format(_dateOfBirth!),
          "place_of_birth": _placeOfBirthController.text,
          "passport_number": _passportNumberController.text,
          "passport_expiry": dateFormat.format(_passportExpiry!),
          "nationality": selectedNationality?.name,
          "receiving_agency": _receivingAgencyController.text,
          "circuit": _circuitController.text,
          "arrival_date": dateFormat.format(_arrivalDate!),
          "expected_departure_date": dateFormat.format(_expectedDepartureDate!),
          "arrival_flight_info": _arrivalFlightInfoController.text,
          "departure_flight_info": _departureFlightInfoController.text,
          "touristic_guide": _touristicGuideController.text,
          "msg_ref": _msgRefController.text,
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تمت إضافة السائح بنجاح')),
        );
      } else {
        setState(() {});

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(' خلل أثناء إضافة السائح')),
        );
      }
    } catch (e) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: SelectableText('Error connecting to the server $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (BuildContext context, setState) {
      return AlertDialog(
          title: const Text(
            "add tourists ",
            textAlign: TextAlign.right,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
              child: Container(
            height: 600,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Icon(
                  Icons.group_add_outlined,
                  size: 50,
                  color: Color.fromARGB(255, 225, 180, 32),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'إضافة سائح جديد',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontFamily: 'Times New Roman',
                      fontSize: 20,
                      letterSpacing:
                          0 /*percentages not used in flutter. defaulting to zero*/,
                      fontWeight: FontWeight.bold,
                      height: 1),
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 25,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 15,
                              ),
                              _buildTextField(_firstNameController, "الإسم"),
                              _buildTextField(_lastNameController, "اللقب"),
                              _buildDatePickerField(
                                  "تاريخ الميلاد", _dateOfBirth, (date) {
                                setState(() {
                                  _dateOfBirth = date;
                                });
                              }),
                              _buildTextField(
                                  _placeOfBirthController, "مكان الميلاد"),
                              const SizedBox(
                                width: 15,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 15,
                              ),
                              _buildTextField(
                                  _passportNumberController, "رقم جواز السفر"),
                              _buildDatePickerField(
                                  "تاريخ الإنتهاء", _passportExpiry, (date) {
                                setState(() {
                                  _passportExpiry = date;
                                });
                              },
                                  rangeStart: DateTime.now()
                                      .subtract(const Duration(days: 0))),
                              SizedBox(
                                height: 85,
                                width: 250,
                                child: DropdownButtonFormField<Nationality>(
                                  isExpanded: false,
                                  isDense: true,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                    ),
                                    prefixIcon: Icon(Icons.abc),
                                    fillColor:
                                        Color.fromARGB(255, 255, 255, 255),
                                    filled: true,
                                    hintText: "الجنسية",
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
                                  validator: (value) {
                                    if (value == null) {
                                      return "يرجى إدخال الجنسية";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              _buildDatePickerField(
                                  " تاريخ الوصول", _arrivalDate, (date) {
                                setState(() {
                                  _arrivalDate = date;
                                });
                              },
                                  rangeStart: DateTime.now()
                                      .subtract(const Duration(days: 3))),
                              const SizedBox(
                                width: 15,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 15,
                              ),
                              _buildTextField(_arrivalFlightInfoController,
                                  "معلومات الوصول"),
                              _buildDatePickerField("التاريخ المتوقع للمغادرة",
                                  _expectedDepartureDate, (date) {
                                setState(() {
                                  _expectedDepartureDate = date;
                                });
                              },
                                  rangeStart: DateTime.now()
                                      .subtract(const Duration(days: 1))),
                              _buildTextField(_departureFlightInfoController,
                                  "معلومات المغادرة"),
                              _buildTextField(_msgRefController, "المرجع"),
                              const SizedBox(
                                width: 15,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 15,
                              ),
                              _buildTextField(_receivingAgencyController,
                                  "الوكالة السياحية"),
                              _buildTextField(_circuitController, "المسار"),
                              _buildTextField(
                                  _touristicGuideController, "المرشد السياحي"),
                              const SizedBox(
                                width: 15,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 15,
                              ),
                              ElevatedButton(
                                onPressed:
                                    _clearForm, // Call the clear function
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 224, 232, 235),
                                  elevation: 5,
                                ),
                                child: const Text("مسح الإستمارة"),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              ElevatedButton(
                                style: const ButtonStyle(
                                    elevation: WidgetStatePropertyAll(5),
                                    backgroundColor: WidgetStatePropertyAll(
                                        Color.fromARGB(255, 7, 80, 122))),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    // All validations passed
                                    _isLoading ? null : _addtourist();
                                  }
                                },
                                child: _isLoading
                                    ? const CircularProgressIndicator(
                                        color:
                                            Color.fromARGB(255, 233, 191, 24))
                                    : const Text(
                                        'إضافة السائح',
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 255, 255, 255)),
                                      ),
                              ),
                              const SizedBox(
                                width: 50,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )));
    });
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: SizedBox(
          height: 70,
          width: 250,
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.abc),
              fillColor: const Color.fromARGB(255, 255, 255, 255),
              filled: true,
              labelText: label,
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "يرجى إدخال $label";
              }
              return null;
            },
          ),
        ));
  }

  Widget _buildDatePickerField(
      String label, DateTime? selectedDate, Function(DateTime) onDateSelected,
      {DateTime? rangeStart, DateTime? rangeEnd}) {
    // Define the RFC 1123 formatter
    final DateFormat rfc1123Format =
        DateFormat('EEE, dd MMM yyyy HH:mm:ss \'GMT\'');

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: GestureDetector(
        onTap: () async {
          DateTime initialDate = selectedDate ?? DateTime.now();
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: initialDate,
            firstDate: rangeStart ?? DateTime(1900),
            lastDate: rangeEnd ?? DateTime(2100),
          );
          if (pickedDate != null) {
            pickedDate = pickedDate.toLocal();
            onDateSelected(pickedDate);
          }
        },
        child: AbsorbPointer(
          child: SizedBox(
              height: 70,
              width: 250,
              child: TextFormField(
                decoration: InputDecoration(
                  fillColor: const Color.fromARGB(255, 255, 255, 255),
                  filled: true,
                  labelText: selectedDate == null
                      ? label
                      : " ${rfc1123Format.format(selectedDate)}",
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  suffixIcon: const Icon(Icons.calendar_today),
                ),
                validator: (value) {
                  if (selectedDate == null) {
                    return "يرجى إدخال $label ";
                  }
                  return null;
                },
              )),
        ),
      ),
    );
  }
}
