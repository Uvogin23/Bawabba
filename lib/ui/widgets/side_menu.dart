import 'package:bawabba/core/services/auth_provider.dart';
import 'package:bawabba/main.dart';
import 'package:bawabba/ui/screens/algerian_screen.dart';
import 'package:bawabba/ui/screens/citizen_screen.dart';
import 'package:bawabba/ui/screens/diplomats_screen.dart';
import 'package:bawabba/ui/screens/gestion_comptes.dart';
import 'package:bawabba/ui/screens/home_page.dart';
import 'package:bawabba/ui/screens/non_residents_screen.dart';
import 'package:bawabba/ui/screens/tourists_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth * 0.185,
      height: screenHeight * 1,
      decoration: const BoxDecoration(
        color: Color.fromRGBO(255, 255, 255, 1),
      ),
      child: Stack(
        children: <Widget>[
          const Positioned(
              top: 65,
              right: 100,
              child: Text(
                'تطبيقة متابعة الدخول و الخروج\nعبر حدود ولاية جانت',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 1),
                    fontFamily: 'Times New Roman',
                    fontSize: 17,
                    letterSpacing:
                        0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.bold,
                    height: 1),
              )),

          Positioned(
            top: 38,
            right: 24,
            child: Container(
              width: 70,
              height: 79.0,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/Exchange1.png'),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),

          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyHomePage()),
              );
            },
            child: Stack(
              children: [
                Positioned(
                    top: 183,
                    right: 270,
                    child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image:
                                  AssetImage('assets/images/Chevronright.png'),
                              fit: BoxFit.fitWidth),
                        ))),
                const Positioned(
                  top: 180,
                  right: 82,
                  child: Text(
                    'لوحة القيادة',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Color.fromRGBO(24, 87, 159, 1),
                      fontFamily: 'Times New Roman',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      height: 1,
                    ),
                  ),
                ),
                Positioned(
                  top: 174,
                  right: 35,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/Report1.png'),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Add more Positioned widgets as necessary

          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DiplomatsHome()),
              );
            },
            child: Stack(
              children: [
                Positioned(
                    top: 258,
                    right: 270,
                    child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image:
                                  AssetImage('assets/images/Chevronright.png'),
                              fit: BoxFit.fitWidth),
                        ))),
                const Positioned(
                  top: 255,
                  right: 82,
                  child: Text(
                    'الدبلوماسيون',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Color.fromRGBO(24, 87, 159, 1),
                      fontFamily: 'Times New Roman',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      height: 1,
                    ),
                  ),
                ),
                Positioned(
                    top: 248,
                    right: 35,
                    child: Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/images/Diplomats1.png'),
                              fit: BoxFit.fitWidth),
                        ))),
              ],
            ),
          ),

          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TouristsHome()),
              );
            },
            child: Stack(
              children: [
                Positioned(
                    top: 333,
                    right: 270,
                    child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image:
                                  AssetImage('assets/images/Chevronright.png'),
                              fit: BoxFit.fitWidth),
                        ))),
                const Positioned(
                  top: 330,
                  right: 82,
                  child: Text(
                    'السياح الأجانب',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Color.fromRGBO(24, 87, 159, 1),
                      fontFamily: 'Times New Roman',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      height: 1,
                    ),
                  ),
                ),
                Positioned(
                    top: 323,
                    right: 35,
                    child: Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/images/Tourists2.png'),
                              fit: BoxFit.fitWidth),
                        ))),
              ],
            ),
          ),

          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AlgerianTouristsHome()),
              );
            },
            child: Stack(
              children: [
                Positioned(
                    top: 406,
                    right: 270,
                    child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image:
                                  AssetImage('assets/images/Chevronright.png'),
                              fit: BoxFit.fitWidth),
                        ))),
                const Positioned(
                  top: 403,
                  right: 82,
                  child: Text(
                    'السياح الجزائريون ',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Color.fromRGBO(24, 87, 159, 1),
                      fontFamily: 'Times New Roman',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      height: 1,
                    ),
                  ),
                ),
                Positioned(
                    top: 398,
                    right: 35,
                    child: Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/images/Idcard1.png'),
                              fit: BoxFit.fitWidth),
                        ))),
              ],
            ),
          ),

          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const NonResidentsHome()),
              );
            },
            child: Stack(
              children: [
                Positioned(
                    top: 481,
                    right: 270,
                    child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image:
                                  AssetImage('assets/images/Chevronright.png'),
                              fit: BoxFit.fitWidth),
                        ))),
                const Positioned(
                  top: 478,
                  right: 82,
                  child: Text(
                    'الدخول عبر الحدود البرية',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Color.fromRGBO(24, 87, 159, 1),
                      fontFamily: 'Times New Roman',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      height: 1,
                    ),
                  ),
                ),
                Positioned(
                    top: 473,
                    right: 35,
                    child: Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                  'assets/images/Non_residents1.png'),
                              fit: BoxFit.fitWidth),
                        ))),
              ],
            ),
          ),

          // More menu items here, e.g., Diplomates, Touriste étrangers, etc.
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CitizenHome()),
              );
            },
            child: Stack(
              children: [
                Positioned(
                    top: 556,
                    right: 270,
                    child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image:
                                  AssetImage('assets/images/Chevronright.png'),
                              fit: BoxFit.fitWidth),
                        ))),
                const Positioned(
                  top: 553,
                  right: 82,
                  child: Text(
                    'الخروج عبر الحدود البرية ',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Color.fromRGBO(24, 87, 159, 1),
                      fontFamily: 'Times New Roman',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      height: 1,
                    ),
                  ),
                ),
                Positioned(
                    top: 548,
                    right: 35,
                    child: Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/images/Passport1.png'),
                              fit: BoxFit.fitWidth),
                        ))),
              ],
            ),
          ),

          Positioned(
            top: 610, // Adjust position as needed
            right: 78, // Adjust position as needed
            child: GestureDetector(
              onTap: () {
                /*showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Alert"),
                      content: const Text("This is a popup alert dialog."),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () {
                            // Add action if needed
                            Navigator.of(context).pop();
                          },
                          child: const Text("OK"),
                        ),
                      ],
                    );
                  },
                );*/
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const GestionComptesHome()),
                );
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 27),
                decoration: BoxDecoration(
                  color:
                      const Color.fromARGB(255, 0, 75, 132), // Azure blue color
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(255, 107, 108, 108), // Shadow color
                      blurRadius: 8, // Blur radius
                      offset: Offset(0, 1), // Offset in x and y directions
                    ),
                  ],
                ),
                child: const Text(
                  "تسيير الحساب",
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Times New Roman',
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 670, // Adjust position as needed
            right: 78, // Adjust position as needed
            child: GestureDetector(
              onTap: () async {
                Provider.of<AuthProvider>(context, listen: false).logout();
                await windowManager.close();
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 47),
                decoration: BoxDecoration(
                  color:
                      const Color.fromARGB(255, 109, 9, 9), // Azure blue color
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(255, 108, 107, 107), // Shadow color
                      blurRadius: 5, // Blur radius
                      offset: Offset(0, 1), // Offset in x and y directions
                    ),
                  ],
                ),
                child: const Text(
                  "خروج",
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Times New Roman',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
