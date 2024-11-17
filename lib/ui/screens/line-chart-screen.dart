import 'package:flutter/material.dart';
import 'package:bawabba/ui/widgets/line_chart.dart';

class LineChartScreen extends StatelessWidget {
  const LineChartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Simple Line Chart"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: AspectRatio(
            aspectRatio: 1.5,
            child: SimpleLineChart(),
          ),
        ),
      ),
    );
  }
}
