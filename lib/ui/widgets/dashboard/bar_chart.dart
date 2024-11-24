import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;

class BarChartScreen extends StatelessWidget {
  const BarChartScreen({Key? key}) : super(key: key);

  // Fetch months data
  Future<Map<String, int>> fetchChartData() async {
    final url =
        Uri.parse('http://127.0.0.1:5000/api/stats/bardata'); // Update URL
    final response = await http.get(url);

    if (response.statusCode == 200) {
      try {
        return Map<String, int>.from(json.decode(response.body));
      } catch (e) {
        throw Exception('Failed to parse chart data: $e');
      }
    } else {
      throw Exception('Failed to load chart data: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, int>>(
      future: fetchChartData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data available'));
        }

        final data = snapshot.data!;
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: (data.values.reduce((a, b) => a > b ? a : b)).toDouble() +
                  5, // Adjust max Y
              barGroups: data.entries.map((entry) {
                final index = data.keys.toList().indexOf(entry.key);
                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: entry.value.toDouble(),
                      color: _getBarColor(index),
                      width: 15,
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                    ),
                  ],
                );
              }).toList(),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 28,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: const TextStyle(fontSize: 12),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index >= 0 && index < data.keys.length) {
                        return Text(
                          data.keys.toList()[index],
                          style: const TextStyle(fontSize: 10),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                rightTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              gridData: FlGridData(show: false),
              borderData: FlBorderData(show: false),
            ),
          ),
        );
      },
    );
  }

  Color _getBarColor(int index) {
    const colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.red,
      Colors.purple,
      Colors.yellow,
    ];
    return colors[index % colors.length];
  }
}
