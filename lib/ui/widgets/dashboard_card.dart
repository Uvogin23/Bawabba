import 'package:flutter/material.dart';
import 'package:bawabba/core/models/diplomat.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Diplomat>> fetchDiplomats() async {
  final response =
      await http.get(Uri.parse('http://127.0.0.1:5000/api/diplomats/last-two'));

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    print('Fetched Data: ${data.runtimeType}');
    for (var item in data) {
      print('Item: $item');
    }
    List<Diplomat> diplomats = data.map<Diplomat>((item) {
      print('Mapping Item: $item');
      return Diplomat.fromJson(item);
    }).toList();
    print('Mapped List Length: ${diplomats.length}');

    return data.map<Diplomat>((item) => Diplomat.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load diplomats');
  }
}

// ignore: non_constant_identifier_names
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
      margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${diplomat.firstName} ${diplomat.lastName}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text("Nationality: ${diplomat.nationality ?? 'N/A'}"),
            Text("Function: ${diplomat.fonction ?? 'N/A'}"),
            Text(
                "Arrival Date: ${diplomat.arrivalDate?.toLocal().toString().split(' ')[0] ?? 'N/A'}"),
          ],
        ),
      ));
}
