import 'package:bawabba/core/models/tourist.dart';
import 'package:flutter/material.dart';
import 'package:bawabba/core/models/diplomat.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
              columnSpacing: 50.0,
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
                    "جواز السفر",
                    style: TextStyle(
                      fontFamily: 'Times New Roman',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )),
                DataColumn(
                    label: Center(
                  child: Text(
                    "الوظيفة",
                    style: TextStyle(
                      fontFamily: 'Times New Roman',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )),
                DataColumn(
                    label: Center(
                  child: Text(
                    "رقم البطاقة الدبلوماسية",
                    style: TextStyle(
                      fontFamily: 'Times New Roman',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )),
                DataColumn(
                    label: Center(
                  child: Text(
                    "الوكالة السياحية",
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
                DataColumn(
                    label: Center(
                  child: Text(
                    "المرجع",
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
                      diplomat.passportNumber ?? "N/A",
                      style: const TextStyle(
                          fontSize: 10, fontFamily: 'Times New Roman'),
                    ),
                  )),
                  DataCell(Center(
                    child: Text(
                      diplomat.fonction ?? "N/A",
                      style: const TextStyle(
                          fontSize: 10, fontFamily: 'Times New Roman'),
                    ),
                  )),
                  DataCell(Center(
                      child: Text(
                    diplomat.diplomaticCardNumber ?? "N/A",
                    style: const TextStyle(
                        fontSize: 10, fontFamily: 'Times New Roman'),
                  ))),
                  DataCell(Center(
                    child: Text(
                      diplomat.receivingAgency ?? "N/A",
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
                  DataCell(Center(
                    child: Text(
                      diplomat.msgRef ?? "N/A",
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
          padding: const EdgeInsets.fromLTRB(2, 0, 30, 0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 55.0,
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
                      "جواز السفر",
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
                DataColumn(
                    label: Center(
                  child: Text(
                    " رقم الرحلة",
                    style: TextStyle(
                      fontFamily: 'Times New Roman',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )),
                DataColumn(
                  label: Center(
                    child: Text(
                      "الوكالة السياحية",
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
                    "المسار السياحي",
                    style: TextStyle(
                      fontFamily: 'Times New Roman',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )),
                DataColumn(
                    label: Center(
                  child: Text(
                    "المرجع",
                    style: TextStyle(
                      fontFamily: 'Times New Roman',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )),
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
                      tourist.passportNumber ?? "N/A",
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
                  DataCell(Center(
                    child: Text(
                      tourist.arrivalFlightInfo ?? "N/A",
                      style: const TextStyle(
                          fontSize: 10, fontFamily: 'Times New Roman'),
                    ),
                  )),
                  DataCell(Center(
                    child: Text(
                      tourist.receivingAgency ?? "N/A",
                      style: const TextStyle(
                          fontSize: 10, fontFamily: 'Times New Roman'),
                    ),
                  )),
                  DataCell(Center(
                    child: Text(
                      tourist.circuit ?? "N/A",
                      style: const TextStyle(
                          fontSize: 10, fontFamily: 'Times New Roman'),
                    ),
                  )),
                  DataCell(Center(
                    child: Text(
                      tourist.msgRef ?? "N/A",
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
