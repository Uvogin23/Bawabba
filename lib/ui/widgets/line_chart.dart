import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SimpleLineChart extends StatelessWidget {
  const SimpleLineChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Static data
    final months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Apr",
      "May"
    ];
    final touristsData = [50, 40, 60, 55, 70, 50, 40, 60, 55, 70, 70, 50];
    final diplomatsData = [30, 25, 35, 40, 45, 30, 25, 35, 40, 45, 70, 20];
    final algeriansData = [70, 60, 80, 75, 90, 70, 60, 80, 75, 90, 70, 0];

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true), // Show grid lines
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 30, // Adjust the interval for left labels
              getTitlesWidget: (value, meta) => Text(
                value.toInt().toString(),
                style: const TextStyle(fontSize: 10),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < months.length) {
                  return Text(
                    months[value.toInt()],
                    style: const TextStyle(fontSize: 10),
                  );
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
        lineBarsData: [
          _buildLineChartBarData(
              touristsData, const Color.fromARGB(255, 210, 145, 7)),
          _buildLineChartBarData(
              diplomatsData, const Color.fromARGB(255, 5, 78, 8)),
          _buildLineChartBarData(
              algeriansData, const Color.fromARGB(255, 145, 17, 17)),
        ],
        borderData: FlBorderData(
          border: const Border.symmetric(
            horizontal: BorderSide(color: Colors.black, width: 1),
            vertical: BorderSide(color: Colors.black, width: 1),
          ),
        ),
      ),
    );
  }

  LineChartBarData _buildLineChartBarData(List<int> values, Color color) {
    return LineChartBarData(
      spots: values.asMap().entries.map((entry) {
        return FlSpot(entry.key.toDouble(), entry.value.toDouble());
      }).toList(),
      isCurved: false,
      color: color,
      barWidth: 4,
      belowBarData: BarAreaData(
        show: false,
        color: color.withOpacity(0.2),
      ),
    );
  }
}

class MonthlyStatsLineChart extends StatelessWidget {
  final Map<String, List<int>> data;

  const MonthlyStatsLineChart({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final months = data.keys.toList();
    final touristsData = data.values.map((e) => e[0].toDouble()).toList();
    final diplomatsData = data.values.map((e) => e[1].toDouble()).toList();
    final algeriansData = data.values.map((e) => e[2].toDouble()).toList();

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 20, // Adjust interval based on your data
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < months.length) {
                  return Text(
                    months[value.toInt()],
                    style: const TextStyle(fontSize: 10),
                  );
                }
                return const Text('');
              },
              // Rotate the labels to avoid overlap
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
        lineBarsData: [
          _buildLineChartBarData(
              touristsData, const Color.fromARGB(255, 174, 149, 24)),
          _buildLineChartBarData(
              diplomatsData, const Color.fromARGB(255, 68, 29, 128)),
          _buildLineChartBarData(
              algeriansData, const Color.fromARGB(255, 92, 132, 159)),
        ],
        borderData: FlBorderData(
          border: const Border.symmetric(
            horizontal: BorderSide(color: Colors.black, width: 1),
            vertical: BorderSide(color: Colors.black, width: 1),
          ),
        ),
      ),
    );
  }

  LineChartBarData _buildLineChartBarData(List<double> values, Color color) {
    return LineChartBarData(
      spots: values.asMap().entries.map((entry) {
        return FlSpot(entry.key.toDouble(), entry.value);
      }).toList(),
      isCurved: false,
      gradient: LinearGradient(
        colors: [color.withOpacity(0.7), color],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      ),
      barWidth: 4,
      dotData: FlDotData(show: true),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
    );
  }
}

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
        title: '${((value / total) * 100).toStringAsFixed(1)}%',
        titleStyle: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
        radius: 60,
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
          children: chartData.data.keys.map((label) {
            final colorIndex = chartData.data.keys.toList().indexOf(label);
            final color = [
              Colors.blue,
              Colors.green,
              Colors.orange,
              Colors.purple,
            ][colorIndex];
            return LegendItem(color: color, label: label);
          }).toList(),
        ),
      ],
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
