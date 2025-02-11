import 'dart:convert';
import 'package:bawabba/core/services/config.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;

class LineChartScreen2 extends StatelessWidget {
  const LineChartScreen2({Key? key}) : super(key: key);

  // Fetch months data
  Future<List<String>> fetchMonthsData() async {
    final url = Uri.parse('${Config.baseUrl}/api/stats/12months');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return List<String>.from(data);
    } else {
      throw Exception('Failed to load months data');
    }
  }

  // Fetch Algerians data

  // Fetch Tourists data
  Future<List<int>> fetchTouristsData() async {
    final url =
        Uri.parse('${Config.baseUrl}/api/stats/last-12-months-tourists');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return List<int>.from(data);
    } else {
      throw Exception('Failed to load Tourists data');
    }
  }

  // Fetch Diplomats data
  Future<List<int>> fetchDiplomatsData() async {
    final url =
        Uri.parse('${Config.baseUrl}/api/stats/last-12-months-diplomats');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return List<int>.from(data);
    } else {
      throw Exception('Failed to load Diplomats data');
    }
  }

  // Combine all data into one future
  Future<Map<String, dynamic>> fetchAllData() async {
    final months = await fetchMonthsData();
    final tourists = await fetchTouristsData();
    final diplomats = await fetchDiplomatsData();
    return {
      "months": months,
      "tourists": tourists,
      "diplomats": diplomats,
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
          final tourists = data['tourists'] as List<int>;
          final diplomats = data['diplomats'] as List<int>;

          return Padding(
            padding: const EdgeInsets.all(3.0),
            child: LineChart(
              LineChartData(
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
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
                gridData: const FlGridData(show: true),
                borderData: FlBorderData(
                  border: const Border.symmetric(
                    horizontal: BorderSide(color: Colors.black, width: 1),
                    vertical: BorderSide(color: Colors.black, width: 1),
                  ),
                ),
                lineBarsData: [
                  // Line for Algerians

                  // Line for Tourists
                  LineChartBarData(
                    spots: tourists
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
                  LineChartBarData(
                    spots: diplomats
                        .asMap()
                        .entries
                        .map((entry) => FlSpot(
                            entry.key.toDouble(), entry.value.toDouble()))
                        .toList(),
                    isCurved: false,
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 36, 188, 41),
                        Color.fromARGB(255, 36, 188, 41),
                      ],
                    ),
                    barWidth: 4,
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
