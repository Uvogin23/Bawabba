import 'package:bawabba/core/models/tourist.dart';
import 'package:flutter/material.dart';
import 'package:bawabba/core/models/diplomat.dart';
import 'package:bawabba/core/models/citizen.dart';
import 'package:bawabba/core/models/non_resident.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/single_child_widget.dart';

Future<List<Diplomat>> fetchDiplomats() async {
  final response =
      await http.get(Uri.parse('http://127.0.0.1:5000/api/diplomats/last-two'));

  if (response.statusCode == 200) {
    try {
      List<dynamic> data = json.decode(response.body);

      List<Diplomat> list =
          data.map<Diplomat>((item) => Diplomat.fromJson(item)).toList();

      return list;
    } catch (e) {
      print('Error parsing diplomats: $e');
      rethrow; // Re-throw the exception for handling elsewhere
    }
  } else {
    throw Exception('Failed to load diplomats: ${response.statusCode}');
  }
}

Future<List<Tourist>> fetchTourists() async {
  final response =
      await http.get(Uri.parse('http://127.0.0.1:5000/api/tourists/last-two'));

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

Future<List<Citizen>> fetchCitizens() async {
  final response = await http
      .get(Uri.parse('http://127.0.0.1:5000/api/stats/last-two/sortie'));

  if (response.statusCode == 200) {
    try {
      List<dynamic> data = json.decode(response.body);

      List<Citizen> list =
          data.map<Citizen>((item) => Citizen.fromJson(item)).toList();

      return list;
    } catch (e) {
      print('Error parsing tourists: $e');
      rethrow; // Re-throw the exception for handling elsewhere
    }
  } else {
    throw Exception('Failed to load diplomats: ${response.statusCode}');
  }
}

Future<List<NonResident>> fetchNonResidents() async {
  final response = await http
      .get(Uri.parse('http://127.0.0.1:5000/api/stats/last-two/entre'));

  if (response.statusCode == 200) {
    try {
      List<dynamic> data = json.decode(response.body);

      List<NonResident> list =
          data.map<NonResident>((item) => NonResident.fromJson(item)).toList();

      return list;
    } catch (e) {
      print('Error parsing tourists: $e');
      rethrow; // Re-throw the exception for handling elsewhere
    }
  } else {
    throw Exception('Failed to load diplomats: ${response.statusCode}');
  }
}

Widget dataTableDiplomats() {
  return FutureBuilder<List<Diplomat>>(
    future: fetchDiplomats(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text("Error: ${snapshot.error}"));
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const Center(child: Text("No diplomats available"));
      } else {
        // Data is ready, create the DataTable
        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 55.0,
              headingRowHeight: 35.0,
              headingRowColor: WidgetStateProperty.resolveWith(
                  (states) => const Color.fromARGB(255, 160, 197, 214)),
              columns: const [
                DataColumn(
                    label: Center(
                  child: Text(
                    "الإسم",
                    style: TextStyle(
                      //fontSize: 12,
                      fontFamily: 'Times New Roman',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )),
                DataColumn(
                    label: Center(
                  child: Text(
                    "اللقب",
                    style: TextStyle(
                      fontFamily: 'Times New Roman',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )),
                DataColumn(
                    label: Center(
                  child: Text(
                    "الجنسية",
                    style: TextStyle(
                      fontFamily: 'Times New Roman',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )),
                DataColumn(
                    label: Center(
                  child: Text(
                    "تاريخ الوصول",
                    style: TextStyle(
                      fontFamily: 'Times New Roman',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )),
              ],
              rows: snapshot.data!.map((diplomat) {
                return DataRow(cells: [
                  DataCell(Center(
                    child: Text(
                      diplomat.firstName,
                      style: const TextStyle(
                          fontSize: 10, fontFamily: 'Times New Roman'),
                    ),
                  )),
                  DataCell(Center(
                    child: Text(
                      diplomat.lastName,
                      style: const TextStyle(
                          fontSize: 10, fontFamily: 'Times New Roman'),
                    ),
                  )),
                  DataCell(Center(
                    child: Text(
                      diplomat.nationality ?? "N/A",
                      style: const TextStyle(
                          fontSize: 10, fontFamily: 'Times New Roman'),
                    ),
                  )),
                  DataCell(Center(
                    child: Text(
                      diplomat.arrivalDate
                              ?.toLocal()
                              .toString()
                              .split(' ')[0] ??
                          "N/A",
                      style: const TextStyle(
                          fontSize: 10, fontFamily: 'Times New Roman'),
                    ),
                  )),
                ]);
              }).toList(),
            ),
          ),
        );
      }
    },
  );
}

Widget dataTableTourists() {
  return FutureBuilder<List<Tourist>>(
    future: fetchTourists(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text("Error: ${snapshot.error}"));
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const Center(child: Text("No diplomats available"));
      } else {
        // Data is ready, create the DataTable
        return Padding(
          padding: const EdgeInsets.fromLTRB(2, 0, 0, 0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 80.0,
              headingRowHeight: 35.0,
              headingRowColor: WidgetStateProperty.resolveWith(
                  (states) => const Color.fromARGB(255, 130, 179, 145)),
              columns: const [
                DataColumn(
                  label: Center(
                    child: Text(
                      "الإسم",
                      style: TextStyle(
                        //fontSize: 12,
                        fontFamily: 'Times New Roman',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                DataColumn(
                  label: Center(
                    child: Text(
                      "اللقب",
                      style: TextStyle(
                        fontFamily: 'Times New Roman',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                DataColumn(
                  label: Center(
                    child: Text(
                      "الجنسية",
                      style: TextStyle(
                        fontFamily: 'Times New Roman',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                DataColumn(
                  label: Center(
                    child: Text(
                      "تاريخ الوصول",
                      style: TextStyle(
                        fontFamily: 'Times New Roman',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
              rows: snapshot.data!.map((tourist) {
                return DataRow(cells: [
                  DataCell(Center(
                    child: Text(
                      tourist.firstName,
                      style: const TextStyle(
                          fontSize: 10, fontFamily: 'Times New Roman'),
                    ),
                  )),
                  DataCell(Center(
                    child: Text(
                      tourist.lastName,
                      style: const TextStyle(
                          fontSize: 10, fontFamily: 'Times New Roman'),
                    ),
                  )),
                  DataCell(Center(
                    child: Text(
                      tourist.nationality ?? "N/A",
                      style: const TextStyle(
                          fontSize: 10, fontFamily: 'Times New Roman'),
                    ),
                  )),
                  DataCell(Center(
                    child: Text(
                      tourist.arrivalDate?.toLocal().toString().split(' ')[0] ??
                          "N/A",
                      style: const TextStyle(
                          fontSize: 10, fontFamily: 'Times New Roman'),
                    ),
                  )),
                ]);
              }).toList(),
            ),
          ),
        );
      }
    },
  );
}

Widget dataTableCitizens() {
  return FutureBuilder<List<Citizen>>(
    future: fetchCitizens(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text("Error: ${snapshot.error}"));
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const Center(child: Text("No entries available"));
      } else {
        // Data is ready, create the DataTable
        return Padding(
          padding: const EdgeInsets.fromLTRB(2, 0, 0, 0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 80.0,
              headingRowHeight: 35.0,
              headingRowColor: WidgetStateProperty.resolveWith(
                  (states) => const Color.fromARGB(255, 240, 149, 113)),
              columns: const [
                DataColumn(
                  label: Center(
                    child: Text(
                      "الإسم",
                      style: TextStyle(
                        //fontSize: 12,
                        fontFamily: 'Times New Roman',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                DataColumn(
                  label: Center(
                    child: Text(
                      "اللقب",
                      style: TextStyle(
                        fontFamily: 'Times New Roman',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                DataColumn(
                  label: Center(
                    child: Text(
                      "رقم جواز السفر",
                      style: TextStyle(
                        fontFamily: 'Times New Roman',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                DataColumn(
                  label: Center(
                    child: Text(
                      "تاريخ الخروج",
                      style: TextStyle(
                        fontFamily: 'Times New Roman',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
              rows: snapshot.data!.map((citizen) {
                return DataRow(cells: [
                  DataCell(Center(
                    child: Text(
                      citizen.firstName,
                      style: const TextStyle(
                          fontSize: 10, fontFamily: 'Times New Roman'),
                    ),
                  )),
                  DataCell(Center(
                    child: Text(
                      citizen.lastName,
                      style: const TextStyle(
                          fontSize: 10, fontFamily: 'Times New Roman'),
                    ),
                  )),
                  DataCell(Center(
                    child: Text(
                      citizen.passportNumber ?? "N/A",
                      style: const TextStyle(
                          fontSize: 10, fontFamily: 'Times New Roman'),
                    ),
                  )),
                  DataCell(Center(
                    child: Text(
                      citizen.exitDate.toLocal().toString().split(' ')[0] ??
                          "N/A",
                      style: const TextStyle(
                          fontSize: 10, fontFamily: 'Times New Roman'),
                    ),
                  )),
                ]);
              }).toList(),
            ),
          ),
        );
      }
    },
  );
}

Widget dataTableNonResident() {
  return FutureBuilder<List<NonResident>>(
    future: fetchNonResidents(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text("Error: ${snapshot.error}"));
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const Center(child: Text("No entries available"));
      } else {
        // Data is ready, create the DataTable
        return Padding(
          padding: const EdgeInsets.fromLTRB(2, 0, 0, 0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 80.0,
              headingRowHeight: 35.0,
              headingRowColor: WidgetStateProperty.resolveWith(
                  (states) => const Color.fromARGB(255, 224, 243, 119)),
              columns: const [
                DataColumn(
                  label: Center(
                    child: Text(
                      "الإسم",
                      style: TextStyle(
                        //fontSize: 12,
                        fontFamily: 'Times New Roman',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                DataColumn(
                  label: Center(
                    child: Text(
                      "اللقب",
                      style: TextStyle(
                        fontFamily: 'Times New Roman',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                DataColumn(
                  label: Center(
                    child: Text(
                      "رقم جواز السفر",
                      style: TextStyle(
                        fontFamily: 'Times New Roman',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                DataColumn(
                  label: Center(
                    child: Text(
                      "تاريخ الدخول",
                      style: TextStyle(
                        fontFamily: 'Times New Roman',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
              rows: snapshot.data!.map((nonResident) {
                return DataRow(cells: [
                  DataCell(Center(
                    child: Text(
                      nonResident.firstName,
                      style: const TextStyle(
                          fontSize: 10, fontFamily: 'Times New Roman'),
                    ),
                  )),
                  DataCell(Center(
                    child: Text(
                      nonResident.lastName,
                      style: const TextStyle(
                          fontSize: 10, fontFamily: 'Times New Roman'),
                    ),
                  )),
                  DataCell(Center(
                    child: Text(
                      nonResident.passportNumber ?? "N/A",
                      style: const TextStyle(
                          fontSize: 10, fontFamily: 'Times New Roman'),
                    ),
                  )),
                  DataCell(Center(
                    child: Text(
                      nonResident.arrivalDate
                              .toLocal()
                              .toString()
                              .split(' ')[0] ??
                          "N/A",
                      style: const TextStyle(
                          fontSize: 10, fontFamily: 'Times New Roman'),
                    ),
                  )),
                ]);
              }).toList(),
            ),
          ),
        );
      }
    },
  );
}

Widget dataTablesDisplay() {
  return Expanded(
    flex: 1,
    child: Container(
      width: 200,
      height: 600,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 250, 250, 250),
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // ignore: avoid_unnecessary_containers
          Container(
            padding: const EdgeInsets.fromLTRB(0, 10, 20, 0),
            child: const Text(
              'آخر السياح المسجلين بالتطبيقة',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Color.fromRGBO(0, 0, 0, 1),
                fontFamily: 'Times New Roman',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                height: 1.5,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 20, 100, 10),
            child: const Text(
              'آخر الدبلوماسيين دخولا لإقليم الولاية',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Color.fromRGBO(134, 134, 134, 1),
                fontFamily: 'Times New Roman',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                height: 1.5,
              ),
            ),
          ),

          Container(
            height: 150,
            padding: const EdgeInsets.fromLTRB(0, 5, 20, 0),
            child: dataTableDiplomats(),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 30, 100, 10),
            child: const Text(
              'آخر السياح الأجانب دخولا لإقليم الولاية',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Color.fromRGBO(134, 134, 134, 1),
                fontFamily: 'Times New Roman',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                height: 1.5,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 5, 20, 0),
            child: dataTableTourists(),
          ),
        ],
      ),
    ),
  );
}

Widget dataTablesDisplay2() {
  return Expanded(
    flex: 1,
    child: Container(
      width: 200,
      height: 600,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 250, 250, 250),
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // ignore: avoid_unnecessary_containers
          Container(
            padding: const EdgeInsets.fromLTRB(0, 10, 20, 0),
            child: const Text(
              ' الحركة عبر الحدود البرية  ',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Color.fromRGBO(0, 0, 0, 1),
                fontFamily: 'Times New Roman',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                height: 1.5,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 20, 100, 10),
            child: const Text(
              'آخر المواطنين خروجا عبر الحدود البرية',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Color.fromRGBO(134, 134, 134, 1),
                fontFamily: 'Times New Roman',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                height: 1.5,
              ),
            ),
          ),

          Container(
            height: 150,
            padding: const EdgeInsets.fromLTRB(0, 5, 20, 0),
            child: dataTableCitizens(),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 30, 100, 10),
            child: const Text(
              'آخر الرعايا الأجانب دخولا عبر الحدود البرية',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Color.fromRGBO(134, 134, 134, 1),
                fontFamily: 'Times New Roman',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                height: 1.5,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 5, 20, 0),
            child: dataTableNonResident(),
          ),
        ],
      ),
    ),
  );
}
