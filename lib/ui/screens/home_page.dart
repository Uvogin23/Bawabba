import 'package:bawabba/ui/widgets/dashboard/dashboard_table_display.dart';
import 'package:bawabba/ui/widgets/dashboard/dashboard_card_entre.dart';
import 'package:bawabba/ui/widgets/dashboard/dashboard_card_sortie.dart';
import 'package:bawabba/ui/widgets/dashboard/line_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:window_manager/window_manager.dart';
import 'package:bawabba/ui/widgets/dashboard/dashboard_card_tourist.dart';
import 'package:bawabba/ui/widgets/dashboard/dashboard_card_diplomat.dart';
import 'package:bawabba/ui/widgets/dashboard/dashboard_card_alg.dart';
import 'package:bawabba/ui/widgets/dashboard/dashboard_card_acc.dart';
import 'package:bawabba/ui/widgets/dashboard/chart_display.dart';

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
              color: const Color.fromARGB(255, 239, 242, 243),
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
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                                //DashboardCardAcc(),
                                DashboardCardEntre(),
                                DashboardCardSortie(),
                              ],
                            ),
                          ),
                          const SizedBox(height: 50),

                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            width: screenWidth * 0.775,
                            height: 500,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 239, 242, 243),
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ChartDisplay(),
                                ChartDisplayPie(),
                              ],
                            ),
                          ),
                          const SizedBox(height: 50),
                          Container(
                            width: screenWidth * 0.775,
                            height: 500,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 239, 242, 243),
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                BarChartDisplay(),
                                ChartDisplay2(),
                              ],
                            ),
                          ),

                          const SizedBox(height: 50),
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            width: screenWidth * 0.775,
                            height: 470,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color.fromARGB(255, 76, 77, 78),
                                  width: 1),
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                dataTablesDisplay(),
                                dataTablesDisplay2(),
                              ],
                            ),
                          ),
                          // Space between cards and charts
                        ],
                      ),
                    ),
                  ),
                  const Positioned(
                    bottom: 5,
                    left: 15,
                    child: Text(
                      'Developed by OPP/Cheloufi Youcef Ouassim SWMT Djanet  ',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Color.fromARGB(255, 219, 217, 217),
                        fontFamily: 'Times New Roman',
                        fontSize: 8,
                        fontWeight: FontWeight.normal,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const Positioned(
                    bottom: 5,
                    right: 15,
                    child: Text(
                      'Bawabba 2024',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Color.fromARGB(255, 219, 217, 217),
                        fontFamily: 'Times New Roman',
                        fontSize: 8,
                        fontWeight: FontWeight.normal,
                        height: 1.5,
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
