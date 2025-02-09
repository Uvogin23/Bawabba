import 'package:bawabba/core/services/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:window_manager/window_manager.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bawabba/core/services/card_stats.dart';

Future<CardStatistics> fetchStatistics() async {
  final response =
      await http.get(Uri.parse('${Config.baseUrl}/api/stats/non_residents'));

  if (response.statusCode == 200) {
    return CardStatistics.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load statistics');
  }
}

class DashboardCardEntre extends StatelessWidget {
  const DashboardCardEntre({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CardStatistics>(
      future: fetchStatistics(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (snapshot.hasData) {
          CardStatistics stats = snapshot.data!;
          return Expanded(
              child: Container(
                  width: 370,
                  height: 127,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromARGB(255, 76, 77, 78), width: 1),
                    boxShadow: const [
                      BoxShadow(
                        color:
                            Color.fromARGB(255, 255, 255, 255), // Shadow color
                        blurRadius: 10, // Blur radius
                        offset: Offset(0, 1), // Offset in x and y directions
                      ),
                    ],
                    borderRadius: const BorderRadius.only(
                      topLeft: const Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                    color: const Color.fromRGBO(255, 255, 255, 1),
                  ),
                  child: Column(children: [
                    const Padding(
                        padding: EdgeInsets.fromLTRB(0, 14, 25, 0),
                        child: Text(
                          'الدخول عبر الحدود البرية',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 1),
                              fontFamily: 'Times New Roman',
                              fontSize: 16,
                              letterSpacing:
                                  0 /*percentages not used in flutter. defaulting to zero*/,
                              fontWeight: FontWeight.bold,
                              height: 1),
                        )),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Padding(
                                    padding: EdgeInsets.fromLTRB(0, 5, 5, 0),
                                    child: Text(
                                      'العدد الإجمالي',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          color: Color.fromRGBO(0, 104, 173, 1),
                                          fontFamily: 'Times New Roman',
                                          fontSize: 12,
                                          letterSpacing:
                                              0 /*percentages not used in flutter. defaulting to zero*/,
                                          fontWeight: FontWeight.bold,
                                          height: 1),
                                    )),
                                Padding(
                                    padding: EdgeInsets.fromLTRB(0, 5, 5, 0),
                                    child: Text(
                                      '${stats.total}',
                                      textAlign: TextAlign.right,
                                      style: const TextStyle(
                                          color: Color.fromRGBO(0, 0, 0, 1),
                                          fontFamily: 'Times New Roman',
                                          fontSize: 18,
                                          letterSpacing:
                                              0 /*percentages not used in flutter. defaulting to zero*/,
                                          fontWeight: FontWeight.bold,
                                          height: 1),
                                    )),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Padding(
                                    padding: EdgeInsets.fromLTRB(0, 5, 5, 0),
                                    child: Text(
                                      'خلال العام الحالي',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          color: Color.fromRGBO(17, 149, 37, 1),
                                          fontFamily: 'Times New Roman',
                                          fontSize: 12,
                                          letterSpacing:
                                              0 /*percentages not used in flutter. defaulting to zero*/,
                                          fontWeight: FontWeight.bold,
                                          height: 1),
                                    )),
                                const SizedBox(
                                  width: 10,
                                ),
                                Padding(
                                    padding: EdgeInsets.fromLTRB(0, 5, 5, 0),
                                    child: Text(
                                      '${stats.currentYear}',
                                      textAlign: TextAlign.right,
                                      style: const TextStyle(
                                          color: Color.fromRGBO(0, 0, 0, 1),
                                          fontFamily: 'Times New Roman',
                                          fontSize: 18,
                                          letterSpacing:
                                              0 /*percentages not used in flutter. defaulting to zero*/,
                                          fontWeight: FontWeight.bold,
                                          height: 1),
                                    )),
                                const SizedBox(
                                  width: 20,
                                ),
                                const Padding(
                                    padding: EdgeInsets.fromLTRB(0, 5, 5, 0),
                                    child: Text(
                                      'خلال العام الماضي',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          color: Color.fromRGBO(224, 19, 19, 1),
                                          fontFamily: 'Times New Roman',
                                          fontSize: 12,
                                          letterSpacing:
                                              0 /*percentages not used in flutter. defaulting to zero*/,
                                          fontWeight: FontWeight.bold,
                                          height: 1),
                                    )),
                                const SizedBox(
                                  width: 10,
                                ),
                                Padding(
                                    padding: EdgeInsets.fromLTRB(0, 5, 5, 0),
                                    child: Text(
                                      '${stats.lastYear}',
                                      textAlign: TextAlign.right,
                                      style: const TextStyle(
                                          color: Color.fromRGBO(0, 0, 0, 1),
                                          fontFamily: 'Times New Roman',
                                          fontSize: 18,
                                          letterSpacing:
                                              0 /*percentages not used in flutter. defaulting to zero*/,
                                          fontWeight: FontWeight.bold,
                                          height: 1),
                                    )),
                              ],
                            )
                          ],
                        ),
                        Padding(
                            padding: EdgeInsets.fromLTRB(0, 5, 5, 0),
                            child: Container(
                                width: 70,
                                height: 71.75,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/Non_residents1.png'),
                                      fit: BoxFit.fitWidth),
                                ))),
                      ],
                    ),
                  ])));
        } else {
          return const Center(child: Text("No data available"));
        }
      },
    );
  }
}
