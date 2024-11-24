import 'dart:convert';
import 'package:bawabba/core/models/citizen.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;

class LineChartScreen3 extends StatelessWidget {
  const LineChartScreen3({Key? key}) : super(key: key);

  // Fetch months data
  Future<List<String>> fetchMonthsData() async {
    final url = Uri.parse('http://127.0.0.1:5000/api/stats/12months');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return List<String>.from(data);
    } else {
      throw Exception('Failed to load months data');
    }
  }

  // Fetch Algerians data
  Future<List<int>> fetchCitizensData() async {
    final url =
        Uri.parse('http://127.0.0.1:5000/api/stats/last-12-months-citizens');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return List<int>.from(data);
    } else {
      throw Exception('Failed to load citizens data');
    }
  }

  // Fetch Tourists data
  Future<List<int>> fetchNonResidentsData() async {
    final url =
        Uri.parse('http://127.0.0.1:5000/api/stats/last-12-months-tourists');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return List<int>.from(data);
    } else {
      throw Exception('Failed to load Tourists data');
    }
  }

  // Fetch Diplomats data

  // Combine all data into one future
  Future<Map<String, dynamic>> fetchAllData() async {
    final months = await fetchMonthsData();
    final citizens = await fetchCitizensData();
    final nonResidents = await fetchNonResidentsData();

    return {
      "months": months,
      "citizens": citizens,
      "nonResidents": nonResidents,
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: fetchAllData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final data = snapshot.data!;
          final months = data['months'] as List<String>;
          final citizens = data['citizens'] as List<int>;
          final nonResidents = data['nonResidents'] as List<int>;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: LineChart(
              LineChartData(
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 &&
                            value.toInt() < months.length) {
                          return Text(months[value.toInt()],
                              style: const TextStyle(fontSize: 10));
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                    ),
                  ),
                ),
                gridData: FlGridData(show: true),
                borderData: FlBorderData(
                  border: const Border.symmetric(
                    horizontal: BorderSide(color: Colors.black, width: 1),
                    vertical: BorderSide(color: Colors.black, width: 1),
                  ),
                ),
                lineBarsData: [
                  // Line for Algerians
                  LineChartBarData(
                    spots: citizens
                        .asMap()
                        .entries
                        .map((entry) => FlSpot(
                            entry.key.toDouble(), entry.value.toDouble()))
                        .toList(),
                    isCurved: false,
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 145, 17, 17),
                        Color.fromARGB(255, 145, 17, 17)
                      ],
                    ),
                    barWidth: 4,
                    belowBarData: BarAreaData(show: false),
                  ),
                  // Line for Tourists
                  LineChartBarData(
                    spots: nonResidents
                        .asMap()
                        .entries
                        .map((entry) => FlSpot(
                            entry.key.toDouble(), entry.value.toDouble()))
                        .toList(),
                    isCurved: false,
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 210, 145, 7),
                        Color.fromARGB(255, 210, 145, 7)
                      ],
                    ),
                    barWidth: 4,
                    belowBarData: BarAreaData(show: false),
                  ),
                  // Line for Diplomats
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const LegendItem({Key? key, required this.color, required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 5),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
