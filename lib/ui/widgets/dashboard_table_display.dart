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
      print('Fetched Data: $data');

      print('Decoded Data Type: ${data.runtimeType}');
      for (var item in data) {
        print('Item: $item');
      }

      List<Diplomat> list =
          data.map<Diplomat>((item) => Diplomat.fromJson(item)).toList();

      print('Constructed List: $list');
      for (var diplomat in list) {
        print('Diplomat: ${diplomat.firstName} ${diplomat.lastName}');
      }

      return list;
    } catch (e) {
      print('Error parsing diplomats: $e');
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
              headingRowColor: WidgetStateProperty.resolveWith(
                  (states) => const Color.fromARGB(255, 160, 197, 214)),
              columns: const [
                DataColumn(
                  label: Text(
                    "الإسم",
                    style: TextStyle(
                      //fontSize: 12,
                      fontFamily: 'Times New Roman',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "اللقب",
                    style: TextStyle(
                      fontFamily: 'Times New Roman',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "الوظيفة",
                    style: TextStyle(
                      fontFamily: 'Times New Roman',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "الجنسية",
                    style: TextStyle(
                      fontFamily: 'Times New Roman',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
              rows: snapshot.data!.map((diplomat) {
                return DataRow(cells: [
                  DataCell(Text(
                    diplomat.firstName,
                    style: const TextStyle(fontFamily: 'Times New Roman'),
                  )),
                  DataCell(Text(
                    diplomat.lastName,
                    style: const TextStyle(fontFamily: 'Times New Roman'),
                  )),
                  DataCell(Text(
                    diplomat.fonction ?? "N/A",
                    style: const TextStyle(fontFamily: 'Times New Roman'),
                  )),
                  DataCell(Text(
                    diplomat.nationality ?? "N/A",
                    style: const TextStyle(fontFamily: 'Times New Roman'),
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
      width: 100,
      height: 500,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 240, 240, 240),
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // ignore: avoid_unnecessary_containers
          Container(
            padding: EdgeInsets.fromLTRB(0, 10, 20, 0),
            child: const Text(
              'آخر السياح المسجلين بالتطبيقة',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Color.fromRGBO(0, 0, 0, 1),
                fontFamily: 'Times New Roman',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                height: 1.5,
              ),
            ),
          ),
          dataTableDiplomats(),
        ],
      ),
    ),
  );
}
