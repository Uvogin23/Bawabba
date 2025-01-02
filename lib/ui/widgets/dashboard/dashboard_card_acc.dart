import 'dart:convert';
import 'package:bawabba/core/services/config.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:window_manager/window_manager.dart';
import 'package:bawabba/core/services/card_stats.dart';

Future<CardStatistics> fetchStatistics() async {
  final response = await http
      .get(Uri.parse('${Config.baseUrl}/api/stats/diplomat_accompaniment'));

  if (response.statusCode == 200) {
    return CardStatistics.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load statistics');
  }
}

class DashboardCardAcc extends StatelessWidget {
  const DashboardCardAcc({
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
          return Positioned(
            top: 160,
            right: 20,
            child: Container(
              width: 370,
              height: 127,
              decoration: BoxDecoration(
                border: Border.all(
                    color: Color.fromARGB(255, 76, 77, 78), width: 1),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(255, 255, 255, 255),
                    blurRadius: 10,
                    offset: Offset(0, 1),
                  ),
                ],
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: Color.fromRGBO(255, 255, 255, 1),
              ),
              child: Stack(
                children: <Widget>[
                  const Positioned(
                    top: 14,
                    right: 25,
                    child: Text(
                      'مرافقي الدبلوماسيين',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 1),
                          fontFamily: 'Times New Roman',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          height: 1),
                    ),
                  ),
                  const Positioned(
                    top: 44,
                    left: 283,
                    child: Text(
                      'العدد الإجمالي',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: Color.fromRGBO(0, 104, 173, 1),
                          fontFamily: 'Times New Roman',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          height: 1),
                    ),
                  ),
                  Positioned(
                    top: 39,
                    left: 233,
                    child: Text(
                      '${stats.total}',
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 1),
                          fontFamily: 'Times New Roman',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          height: 1),
                    ),
                  ),
                  Positioned(
                    top: 93,
                    left: 299,
                    child: Text(
                      '${stats.currentYear}',
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 1),
                          fontFamily: 'Times New Roman',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          height: 1),
                    ),
                  ),
                  Positioned(
                    top: 93,
                    left: 184,
                    child: Text(
                      '${stats.lastYear}',
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 1),
                          fontFamily: 'Times New Roman',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          height: 1),
                    ),
                  ),
                  const Positioned(
                    top: 77,
                    left: 268,
                    child: Text(
                      'خلال العام الحالي',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: Color.fromRGBO(17, 149, 37, 1),
                          fontFamily: 'Times New Roman',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          height: 1),
                    ),
                  ),
                  const Positioned(
                    top: 77,
                    left: 151,
                    child: Text(
                      'خلال العام الماضي',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: Color.fromRGBO(224, 19, 19, 1),
                          fontFamily: 'Times New Roman',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          height: 1),
                    ),
                  ),
                  Positioned(
                    top: 25,
                    left: 15,
                    child: Container(
                      width: 70,
                      height: 71.75,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                            image:
                                AssetImage('assets/images/public-speaking.png'),
                            fit: BoxFit.fitWidth),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Center(child: Text("No data available"));
        }
      },
    );
  }
}
