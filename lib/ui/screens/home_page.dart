import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:window_manager/window_manager.dart';

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
                      height: 234,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 112, 46, 46),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                      ),
                      child: Stack(children: <Widget>[
                        Positioned(
                            top: 10,
                            right: 20,
                            child: Container(
                                width: 370,
                                height: 127,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                    bottomLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                  ),
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                ),
                                child: Stack(children: <Widget>[
                                  const Positioned(
                                      top: 14,
                                      left: 283,
                                      child: Text(
                                        'الدبلوماسيون',
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
                                  const Positioned(
                                      top: 44,
                                      left: 283,
                                      child: Text(
                                        'العدد الإجمالي',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(0, 104, 173, 1),
                                            fontFamily: 'Times New Roman',
                                            fontSize: 12,
                                            letterSpacing:
                                                0 /*percentages not used in flutter. defaulting to zero*/,
                                            fontWeight: FontWeight.bold,
                                            height: 1),
                                      )),
                                  const Positioned(
                                      top: 39,
                                      left: 233,
                                      child: Text(
                                        '500',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                            color: Color.fromRGBO(0, 0, 0, 1),
                                            fontFamily: 'Times New Roman',
                                            fontSize: 18,
                                            letterSpacing:
                                                0 /*percentages not used in flutter. defaulting to zero*/,
                                            fontWeight: FontWeight.bold,
                                            height: 1),
                                      )),
                                  const Positioned(
                                      top: 93,
                                      left: 299,
                                      child: Text(
                                        '100',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                            color: Color.fromRGBO(0, 0, 0, 1),
                                            fontFamily: 'Times New Roman',
                                            fontSize: 18,
                                            letterSpacing:
                                                0 /*percentages not used in flutter. defaulting to zero*/,
                                            fontWeight: FontWeight.bold,
                                            height: 1),
                                      )),
                                  const Positioned(
                                      top: 93,
                                      left: 184,
                                      child: Text(
                                        '150',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                            color: Color.fromRGBO(0, 0, 0, 1),
                                            fontFamily: 'Times New Roman',
                                            fontSize: 18,
                                            letterSpacing:
                                                0 /*percentages not used in flutter. defaulting to zero*/,
                                            fontWeight: FontWeight.bold,
                                            height: 1),
                                      )),
                                  const Positioned(
                                      top: 77,
                                      left: 268,
                                      child: Text(
                                        'خلال العام الحالي',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(17, 149, 37, 1),
                                            fontFamily: 'Times New Roman',
                                            fontSize: 12,
                                            letterSpacing:
                                                0 /*percentages not used in flutter. defaulting to zero*/,
                                            fontWeight: FontWeight.bold,
                                            height: 1),
                                      )),
                                  const Positioned(
                                      top: 77,
                                      left: 151,
                                      child: Text(
                                        'خلال العام الماضي',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(224, 19, 19, 1),
                                            fontFamily: 'Times New Roman',
                                            fontSize: 12,
                                            letterSpacing:
                                                0 /*percentages not used in flutter. defaulting to zero*/,
                                            fontWeight: FontWeight.bold,
                                            height: 1),
                                      )),
                                  Positioned(
                                      top: 25,
                                      left: 15,
                                      child: Container(
                                          width: 70,
                                          height: 71.75,
                                          decoration: const BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    'assets/images/Diplomats1.png'),
                                                fit: BoxFit.fitWidth),
                                          ))),
                                ]))),
                        Positioned(
                            top: 10,
                            right: 410,
                            child: Container(
                                width: 370,
                                height: 127,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                    bottomLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                  ),
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                ),
                                child: Stack(children: <Widget>[
                                  const Positioned(
                                      top: 14,
                                      left: 283,
                                      child: Text(
                                        'الدبلوماسيون',
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
                                  const Positioned(
                                      top: 44,
                                      left: 283,
                                      child: Text(
                                        'العدد الإجمالي',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(0, 104, 173, 1),
                                            fontFamily: 'Times New Roman',
                                            fontSize: 12,
                                            letterSpacing:
                                                0 /*percentages not used in flutter. defaulting to zero*/,
                                            fontWeight: FontWeight.bold,
                                            height: 1),
                                      )),
                                  const Positioned(
                                      top: 39,
                                      left: 233,
                                      child: Text(
                                        '500',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                            color: Color.fromRGBO(0, 0, 0, 1),
                                            fontFamily: 'Times New Roman',
                                            fontSize: 18,
                                            letterSpacing:
                                                0 /*percentages not used in flutter. defaulting to zero*/,
                                            fontWeight: FontWeight.bold,
                                            height: 1),
                                      )),
                                  const Positioned(
                                      top: 93,
                                      left: 299,
                                      child: Text(
                                        '100',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                            color: Color.fromRGBO(0, 0, 0, 1),
                                            fontFamily: 'Times New Roman',
                                            fontSize: 18,
                                            letterSpacing:
                                                0 /*percentages not used in flutter. defaulting to zero*/,
                                            fontWeight: FontWeight.bold,
                                            height: 1),
                                      )),
                                  const Positioned(
                                      top: 93,
                                      left: 184,
                                      child: Text(
                                        '150',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                            color: Color.fromRGBO(0, 0, 0, 1),
                                            fontFamily: 'Times New Roman',
                                            fontSize: 18,
                                            letterSpacing:
                                                0 /*percentages not used in flutter. defaulting to zero*/,
                                            fontWeight: FontWeight.bold,
                                            height: 1),
                                      )),
                                  const Positioned(
                                      top: 77,
                                      left: 268,
                                      child: Text(
                                        'خلال العام الحالي',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(17, 149, 37, 1),
                                            fontFamily: 'Times New Roman',
                                            fontSize: 12,
                                            letterSpacing:
                                                0 /*percentages not used in flutter. defaulting to zero*/,
                                            fontWeight: FontWeight.bold,
                                            height: 1),
                                      )),
                                  const Positioned(
                                      top: 77,
                                      left: 151,
                                      child: Text(
                                        'خلال العام الماضي',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(224, 19, 19, 1),
                                            fontFamily: 'Times New Roman',
                                            fontSize: 12,
                                            letterSpacing:
                                                0 /*percentages not used in flutter. defaulting to zero*/,
                                            fontWeight: FontWeight.bold,
                                            height: 1),
                                      )),
                                  Positioned(
                                      top: 25,
                                      left: 15,
                                      child: Container(
                                          width: 70,
                                          height: 71.75,
                                          decoration: const BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    'assets/images/Diplomats1.png'),
                                                fit: BoxFit.fitWidth),
                                          ))),
                                ]))),
                        Positioned(
                            top: 10,
                            right: 800,
                            child: Container(
                                width: 370,
                                height: 127,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                    bottomLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                  ),
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                ),
                                child: Stack(children: <Widget>[
                                  const Positioned(
                                      top: 14,
                                      left: 283,
                                      child: Text(
                                        'الدبلوماسيون',
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
                                  const Positioned(
                                      top: 44,
                                      left: 283,
                                      child: Text(
                                        'العدد الإجمالي',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(0, 104, 173, 1),
                                            fontFamily: 'Times New Roman',
                                            fontSize: 12,
                                            letterSpacing:
                                                0 /*percentages not used in flutter. defaulting to zero*/,
                                            fontWeight: FontWeight.bold,
                                            height: 1),
                                      )),
                                  const Positioned(
                                      top: 39,
                                      left: 233,
                                      child: Text(
                                        '500',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                            color: Color.fromRGBO(0, 0, 0, 1),
                                            fontFamily: 'Times New Roman',
                                            fontSize: 18,
                                            letterSpacing:
                                                0 /*percentages not used in flutter. defaulting to zero*/,
                                            fontWeight: FontWeight.bold,
                                            height: 1),
                                      )),
                                  const Positioned(
                                      top: 93,
                                      left: 299,
                                      child: Text(
                                        '100',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                            color: Color.fromRGBO(0, 0, 0, 1),
                                            fontFamily: 'Times New Roman',
                                            fontSize: 18,
                                            letterSpacing:
                                                0 /*percentages not used in flutter. defaulting to zero*/,
                                            fontWeight: FontWeight.bold,
                                            height: 1),
                                      )),
                                  const Positioned(
                                      top: 93,
                                      left: 184,
                                      child: Text(
                                        '150',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                            color: Color.fromRGBO(0, 0, 0, 1),
                                            fontFamily: 'Times New Roman',
                                            fontSize: 18,
                                            letterSpacing:
                                                0 /*percentages not used in flutter. defaulting to zero*/,
                                            fontWeight: FontWeight.bold,
                                            height: 1),
                                      )),
                                  const Positioned(
                                      top: 77,
                                      left: 268,
                                      child: Text(
                                        'خلال العام الحالي',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(17, 149, 37, 1),
                                            fontFamily: 'Times New Roman',
                                            fontSize: 12,
                                            letterSpacing:
                                                0 /*percentages not used in flutter. defaulting to zero*/,
                                            fontWeight: FontWeight.bold,
                                            height: 1),
                                      )),
                                  const Positioned(
                                      top: 77,
                                      left: 151,
                                      child: Text(
                                        'خلال العام الماضي',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(224, 19, 19, 1),
                                            fontFamily: 'Times New Roman',
                                            fontSize: 12,
                                            letterSpacing:
                                                0 /*percentages not used in flutter. defaulting to zero*/,
                                            fontWeight: FontWeight.bold,
                                            height: 1),
                                      )),
                                  Positioned(
                                      top: 25,
                                      left: 15,
                                      child: Container(
                                          width: 70,
                                          height: 71.75,
                                          decoration: const BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    'assets/images/Diplomats1.png'),
                                                fit: BoxFit.fitWidth),
                                          ))),
                                ]))),
                      ]))
                ],
              ),
            ),
          ),
        ]));
  }
}
