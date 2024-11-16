import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
        width: screenWidth * 1,
        height: screenHeight * 1,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(1),
            topRight: Radius.circular(1),
            bottomLeft: Radius.circular(1),
            bottomRight: Radius.circular(1),
          ),
          boxShadow: [
            BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.25),
                offset: Offset(0, 4),
                blurRadius: 34)
          ],
          color: Color.fromRGBO(255, 255, 255, 1),
        ),
        child: Stack(children: <Widget>[
          Positioned(
              top: 150,
              left: 200,
              right: 200,
              bottom: 150,
              child: Container(
                  width: screenWidth * 0.8,
                  height: screenHeight * 0.8,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    color: Color.fromRGBO(25, 83, 153, 1),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(255, 82, 83, 99), // Shadow color
                        blurRadius: 10, // Blur radius
                        offset: Offset(0, 0), // Offset in x and y directions
                      ),
                    ],
                  ))),
          Positioned(
              top: 270,
              left: 1000,
              right: 300,
              bottom: 270,
              child: //Mask holder Template
                  Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        color: Color.fromRGBO(255, 255, 255, 1),
                        boxShadow: [
                          BoxShadow(
                            color:
                                Color.fromARGB(255, 82, 83, 99), // Shadow color
                            blurRadius: 10, // Blur radius
                            offset:
                                Offset(0, 0), // Offset in x and y directions
                          ),
                        ],
                      ),
                      child: null)),
          Positioned(
            top: 330,
            left: 490,
            child: Container(
              width: 200,
              height: 200.0,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/change.png'),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          const Positioned(
            top: 570,
            left: 450,
            child: Text(
              'تطبيقة متابعة الدخول و الخروج\nعبر حدود ولاية جانت',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(255, 255, 255, 1),
                fontFamily: 'Times New Roman',
                fontSize: 25,
                fontWeight: FontWeight.bold,
                height: 1,
              ),
            ),
          ),
        ]));
  }
}
