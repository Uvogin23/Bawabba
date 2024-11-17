import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:window_manager/window_manager.dart';

class DashboardCardAlg extends StatelessWidget {
  const DashboardCardAlg({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: 10,
        right: 800,
        child: Container(
            width: 370,
            height: 127,
            decoration: const BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(255, 207, 204, 204), // Shadow color
                  blurRadius: 10, // Blur radius
                  offset: Offset(0, 1), // Offset in x and y directions
                ),
              ],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
              color: Color.fromRGBO(252, 244, 221, 1),
            ),
            child: Stack(children: <Widget>[
              const Positioned(
                  top: 14,
                  right: 25,
                  child: Text(
                    'السياح الجزائريون',
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
                        color: Color.fromRGBO(0, 104, 173, 1),
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
                        color: Color.fromRGBO(17, 149, 37, 1),
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
                        color: Color.fromRGBO(224, 19, 19, 1),
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
                            image: AssetImage('assets/images/idCard1.png'),
                            fit: BoxFit.fitWidth),
                      ))),
            ])));
  }
}
