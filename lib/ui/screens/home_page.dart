import 'package:bawabba/ui/widgets/dashboard_card_entre.dart';
import 'package:bawabba/ui/widgets/dashboard_card_sortie.dart';
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

    return Container(
        width: screenWidth * 0.815,
        height: screenHeight,
        color: const Color.fromARGB(255, 246, 246, 246),
        child: Stack(children: <Widget>[
          const Positioned(
            top: 11,
            right: 20,
            child: Text(
              'الصفحات / لوحة القيادة',
              textAlign: TextAlign.right,
              style: TextStyle(
                color:
                    Color.fromARGB(255, 106, 106, 106), // Define the color here
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
            top: 100, // Adjust this to add space below the title
            bottom: 30,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                      width: 1206,
                      height: 300,
                      decoration: const BoxDecoration(
                        //color: Color.fromARGB(255, 235, 232, 232),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                      ),
                      child: const Stack(children: <Widget>[
                        DashboardCardDiplomat(),
                        DashboardCardTourist(),
                        DashboardCardAlg(),
                        DashboardCardAcc(),
                        DashboardCardEntre(),
                        DashboardCardSortie()
                      ]))
                ],
              ),
            ),
          ),
        ]));
  }
}
