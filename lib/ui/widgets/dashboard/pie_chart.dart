import 'package:bawabba/core/services/config.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bawabba/core/services/card_stats.dart';
import 'package:bawabba/ui/widgets/dashboard/line_chart.dart';
import 'package:bawabba/ui/widgets/dashboard/line_chartT.dart';

class CustomPieChartData {
  final Map<String, int> data;

  CustomPieChartData(this.data);
}

class PieChartWidget extends StatelessWidget {
  final CustomPieChartData chartData;

  const PieChartWidget({Key? key, required this.chartData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final total = chartData.data.values.reduce((a, b) => a + b);

    // Create pie chart sections
    final pieSections =
        chartData.data.entries.toList().asMap().entries.map((entry) {
      final index = entry.key;
      // ignore: unused_local_variable
      final label = entry.value.key;
      final value = entry.value.value;

      // Define colors for each category
      final color = [
        Colors.blue, // Diplomats
        Colors.green, // Algerian Tourists
        Colors.orange, // Tourists
        Colors.purple, // Accompaniments
      ][index];

      return PieChartSectionData(
        color: color,
        value: value.toDouble(),
        showTitle: false,
        title: '${((value / total) * 100).toStringAsFixed(1)}%',
        titleStyle: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
        radius: 50,
      );
    }).toList();

    return Column(
      children: [
        SizedBox(
          height: 300,
          child: PieChart(
            PieChartData(
              sections: pieSections,
              sectionsSpace: 4,
              centerSpaceRadius: 50,
              borderData: FlBorderData(show: false),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 20,
          children: chartData.data.entries.map((entry) {
            final label = entry.key;
            final value = entry.value;
            final percentage = ((value / total) * 100).toStringAsFixed(1);

            final colorIndex = chartData.data.keys.toList().indexOf(label);
            final color = [
              Colors.blue,
              Colors.green,
              Colors.orange,
              Colors.purple,
            ][colorIndex];

            return LegendItem(
              color: color,
              label: '$label: $percentage%', // Combine label with percentage
            );
          }).toList(),
        ),
      ],
    );
  }
}

Widget futurePiechart() {
  return FutureBuilder<CustomPieChartData>(
    future: fetchPieChartStatistics(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return const Center(child: Text("Error loading data"));
      } else if (snapshot.hasData) {
        return Center(
          child: PieChartWidget(
              chartData: snapshot.data!), // Pass the data to PieChartWidget
        );
      } else {
        return const Center(child: Text("No data available"));
      }
    },
  );
}

Future<CustomPieChartData> fetchPieChartStatistics() async {
  final response =
      await http.get(Uri.parse('${Config.baseUrl}/api/stats/overall_counts'));

  if (response.statusCode == 200) {
    try {
      final data = json.decode(response.body) as Map<String, dynamic>;
      return CustomPieChartData(
          data.map((key, value) => MapEntry(key, value as int)));
    } catch (e) {
      throw Exception('Error parsing chart data: $e');
    }
  } else {
    throw Exception('Failed to fetch chart data: ${response.statusCode}');
  }
}
