import 'package:flutter/material.dart';
import 'package:bawabba/ui/widgets/line_chart.dart';

Widget ChartDisplay() {
  return Expanded(
    flex: 1, // Adjust width proportions for the charts
    child: Container(
        height: 600, // Chart height
        margin: const EdgeInsets.fromLTRB(10, 0, 50, 0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 250, 250, 250),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 0,
              offset: const Offset(1, 1),
            ),
          ],
        ),
        child: Stack(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(10, 90, 20, 50),
              child: SimpleLineChart(), // First Chart
            ),
            const Positioned(
              top: 10,
              right: 30,
              child: Text(
                'تطور عدد السياح بإقليم الولاية :',
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
            const Positioned(
              top: 40,
              right: 30,
              child: Text(
                'خلال 12 شهر الماضية',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Color.fromRGBO(110, 109, 109, 1),
                  fontFamily: 'Times New Roman',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  height: 1.5,
                ),
              ),
            ),
            Positioned(
              bottom: 15,
              right: 52,
              child: lineType('الدبلوماسيون'),
            ),
            Positioned(
              bottom: 20,
              right: 35,
              child: legendKey(5, 78, 8),
            ),
            Positioned(
              bottom: 15,
              right: 180,
              child: lineType('السياح الأجانب'),
            ),
            Positioned(
              bottom: 20,
              right: 163,
              child: legendKey(210, 145, 7),
            ),
            Positioned(
              bottom: 15,
              right: 308,
              child: lineType('السواح الجزائريون'),
            ),
            Positioned(
              bottom: 20,
              right: 291,
              child: legendKey(145, 17, 17),
            ),
          ],
        )),
  );
}

Widget ChartDisplay2() {
  return Expanded(
    flex: 2,
    child: Container(
        height: 600,
        // Chart height
        margin: const EdgeInsets.fromLTRB(50, 0, 10, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(10, 90, 50, 50),
          child: FutureBuilder<Map<String, List<int>>>(
            future: fetchChartData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: MonthlyStatsLineChart(
                    data: snapshot.data!,
                  ),
                );
              } else {
                return const Text("No data available.");
              }
            },
          ),
        )),
  );
}

Future<Map<String, List<int>>> fetchChartData() async {
  // Simulate API response
  await Future.delayed(const Duration(seconds: 2)); // Simulate network delay
  return {
    "January": [50, 30, 70], // Tourists, Diplomats, Algerians
    "February": [40, 25, 60],
    "March": [60, 35, 80],
    "April": [55, 40, 75],
    "May": [55, 40, 75],
    "June": [55, 40, 75],
    "July": [60, 35, 80],
    "August": [55, 40, 75],
    "Septembre": [40, 25, 60],
    "Octobre": [55, 40, 75],
    "Novembre": [30, 70, 75],
    "Decembre": [55, 40, 75],
  };
}

Widget legendKey(int r, int g, int b) {
  return Container(
    height: 12,
    width: 12,
    decoration: BoxDecoration(
      color: Color.fromARGB(255, r, g, b),
      borderRadius: BorderRadius.circular(15),
    ),
  );
}

Widget lineType(String type) {
  return Text(
    type,
    textAlign: TextAlign.right,
    style: const TextStyle(
      color: Color.fromRGBO(0, 0, 0, 1),
      fontFamily: 'Times New Roman',
      fontSize: 14,
      fontWeight: FontWeight.bold,
      height: 1.5,
    ),
  );
}
