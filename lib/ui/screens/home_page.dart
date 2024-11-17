import 'package:bawabba/ui/widgets/dashboard_card_entre.dart';
import 'package:bawabba/ui/widgets/dashboard_card_sortie.dart';
import 'package:bawabba/ui/widgets/line_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:window_manager/window_manager.dart';
import 'package:bawabba/ui/widgets/dashboard_card_tourist.dart';
import 'package:bawabba/ui/widgets/dashboard_card_diplomat.dart';
import 'package:bawabba/ui/widgets/dashboard_card_alg.dart';
import 'package:bawabba/ui/widgets/dashboard_card_acc.dart';

class MainContent extends StatelessWidget {
  const MainContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Expanded(
        flex: 1,
        child: Column(
          children: [
            Container(
              width: screenWidth * 0.815,
              height: screenHeight,
              color: const Color.fromARGB(255, 255, 255, 255),
              child: Stack(
                children: <Widget>[
                  const Positioned(
                    top: 11,
                    right: 20,
                    child: Text(
                      'الصفحات / لوحة القيادة',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Color.fromARGB(255, 106, 106, 106),
                        fontFamily: 'Times New Roman',
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const Positioned(
                    top: 36,
                    right: 30,
                    child: Text(
                      'لـــوحة القيــــادة',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 1),
                        fontFamily: 'Times New Roman',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        height: 1.5,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    right: 0,
                    top: 100,
                    bottom: 30,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            width: 1200,
                            height: 300,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                            child: const Stack(
                              children: <Widget>[
                                DashboardCardDiplomat(),
                                DashboardCardTourist(),
                                DashboardCardAlg(),
                                DashboardCardAcc(),
                                DashboardCardEntre(),
                                DashboardCardSortie(),
                              ],
                            ),
                          ),
                          const SizedBox(
                              height: 50), // Space between cards and charts
                          Container(
                            width: 1500,
                            height: 450,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex:
                                      1, // Adjust width proportions for the charts
                                  child: Container(
                                      height: 600, // Chart height
                                      margin: const EdgeInsets.fromLTRB(
                                          10, 0, 50, 0),
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 255, 255, 255),
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 0,
                                            offset: const Offset(0, 5),
                                          ),
                                        ],
                                      ),
                                      child: const Stack(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(16.0),
                                            child:
                                                SimpleLineChart(), // First Chart
                                          ),
                                        ],
                                      )),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    height: 600,
                                    // Chart height
                                    margin:
                                        const EdgeInsets.fromLTRB(50, 0, 10, 0),
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
                                    child:
                                        FutureBuilder<Map<String, List<int>>>(
                                      future: fetchChartData(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
                                        } else if (snapshot.hasError) {
                                          return Text(
                                              "Error: ${snapshot.error}");
                                        } else if (snapshot.hasData) {
                                          return Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: MonthlyStatsLineChart(
                                              data: snapshot.data!,
                                            ),
                                          );
                                        } else {
                                          return const Text(
                                              "No data available.");
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
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
    "July": [55, 40, 75],
    "August": [55, 40, 75],
    "Septembre": [55, 40, 75],
    "Octobre": [55, 40, 75],
    "Novembre": [55, 40, 75],
    "Decembre": [55, 40, 75],
  };
}
