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

Widget FutureDiplomatCards() {
  return FutureBuilder<List<Diplomat>>(
    future: fetchDiplomats(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return const Center(child: Text("Error loading data"));
      } else if (snapshot.hasData) {
        final diplomats = snapshot.data!;
        return ListView.builder(
          itemCount: diplomats.length,
          itemBuilder: (context, index) {
            final diplomat = diplomats[index];
            return DiplomatCard(diplomat);
          },
        );
      } else {
        return const Center(child: Text("No data available"));
      }
    },
  );
}

Widget DiplomatCard(Diplomat diplomat) {
  return Card(
      color: Colors.white,
      margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "${diplomat.firstName} ${diplomat.lastName}",
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
                "Nationality: ${diplomat.arrivalDate?.toLocal().toString().split(' ')[0] ?? 'N/A'}"),
            Text("Function: ${diplomat.fonction ?? 'N/A'}"),
            Text(
                "Arrival Date: ${diplomat.arrivalDate?.toLocal().toString().split(' ')[0] ?? 'N/A'}"),
          ],
        ),
      ));
}

Widget tableBuilder() {
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
        // Data is ready, create the table
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Table(
            border: TableBorder.all(color: Colors.black),
            columnWidths: const {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(3),
              2: FlexColumnWidth(3),
              3: FlexColumnWidth(2),
              4: FlexColumnWidth(2),
            },
            children: [
              // Header Row
              const TableRow(
                children: [
                  TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "ID",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "First Name",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Last Name",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Fonction",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Nationality",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              // Data Rows
              ...snapshot.data!.map((diplomat) {
                return TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(diplomat.id.toString()),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(diplomat.firstName),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(diplomat.lastName),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(diplomat.fonction ?? "N/A"),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(diplomat.nationality ?? "N/A"),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ],
          ),
        );
      }
    },
  );
}
