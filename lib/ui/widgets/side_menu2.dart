import 'package:bawabba/core/services/auth_provider.dart';
import 'package:bawabba/core/services/config.dart';
import 'package:bawabba/main.dart';
import 'package:bawabba/ui/screens/algerian_screen.dart';
import 'package:bawabba/ui/screens/army_login_page.dart';
import 'package:bawabba/ui/screens/citizen_screen.dart';
import 'package:bawabba/ui/screens/diplomats_screen.dart';
import 'package:bawabba/ui/screens/gestion_comptes.dart';
import 'package:bawabba/ui/screens/home_page.dart';
import 'package:bawabba/ui/screens/non_residents_screen.dart';
import 'package:bawabba/ui/screens/police_login_screen.dart';
import 'package:bawabba/ui/screens/tourists_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

class SideMenu2 extends StatefulWidget {
  const SideMenu2({
    super.key,
  });

  @override
  State<SideMenu2> createState() => _SideMenu2();
}

class _SideMenu2 extends State<SideMenu2> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    final sideMenu = Provider.of<AuthProvider>(context, listen: false).sideMenu;
    if (sideMenu == true) {
      return Container(
          width: screenWidth * 0.185,
          height: screenHeight * 1,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(1),
            ),
            color: Color.fromRGBO(255, 255, 255, 1),
            border: Border(
              left:
                  BorderSide(color: Color.fromARGB(255, 76, 77, 78), width: 1),
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                      child: GestureDetector(
                    onTap: () {
                      setState(() {
                        Provider.of<AuthProvider>(context, listen: false)
                            .sideMenu = false;
                      });
                    },
                    child: Container(
                      width: 70,
                      height: 79.0,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/Logo.png'),
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                  )),
                  const SizedBox(
                    height: 10,
                  ),
                  const Center(
                    child: Text(
                      'تطبيقة متابعة الدخول و الخروج\nعبر حدود ولاية جانت',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 1),
                          fontFamily: 'Times New Roman',
                          fontSize: 18,
                          letterSpacing:
                              0 /*percentages not used in flutter. defaulting to zero*/,
                          fontWeight: FontWeight.bold,
                          height: 1),
                    ),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  ListTile(
                    onTap: () {
                      if (token != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MyHomePage()),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreenPolice()),
                        );
                      }
                    },
                    leading: const Icon(
                      Icons.space_dashboard_rounded,
                      color: Config.colorPrimary,
                      size: 25,
                    ),
                    trailing: const Icon(
                      Icons.chevron_right_rounded,
                      color: Color.fromARGB(255, 233, 191, 24),
                      size: 30,
                    ),
                    title: const Text(
                      'لــــوحة القيــــادة',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                    contentPadding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                    selectedTileColor: const Color.fromARGB(255, 233, 191, 24),
                    hoverColor: const Color.fromARGB(255, 233, 191, 24),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ListTile(
                    onTap: () {
                      if (token != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const DiplomatsHome()),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreenPolice()),
                        );
                      }
                    },
                    leading: const Icon(
                      Icons.people_sharp,
                      color: Config.colorPrimary,
                      size: 25,
                    ),
                    trailing: const Icon(
                      Icons.chevron_right_rounded,
                      color: Color.fromARGB(255, 233, 191, 24),
                      size: 30,
                    ),
                    title: const Text(
                      'الدبـلومـــاسيــون',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                    contentPadding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                    selectedTileColor: const Color.fromARGB(255, 233, 191, 24),
                    hoverColor: const Color.fromARGB(255, 233, 191, 24),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ListTile(
                    onTap: () {
                      if (token != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TouristsHome()),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreenPolice()),
                        );
                      }
                    },
                    leading: const Icon(
                      Icons.connecting_airports_rounded,
                      color: Config.colorPrimary,
                      size: 30,
                    ),
                    trailing: const Icon(
                      Icons.chevron_right_rounded,
                      color: Color.fromARGB(255, 233, 191, 24),
                      size: 30,
                    ),
                    title: const Text(
                      'السيــاح الأجــانب',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                    contentPadding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                    selectedTileColor: const Color.fromARGB(255, 233, 191, 24),
                    hoverColor: const Color.fromARGB(255, 233, 191, 24),
                  ),

                  /*ListTile(
                    onTap: () {
                      if (token != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const AlgerianTouristsHome()),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreenPolice()),
                        );
                      }
                    },
                    leading: const Icon(
                      Icons.flag,
                      color: Config.colorPrimary,
                      size: 25,
                    ),
                    trailing: const Icon(
                      Icons.chevron_right_rounded,
                      color: Color.fromARGB(255, 233, 191, 24),
                      size: 30,
                    ),
                    title: const Text(
                      'السيـاح الجزائريون',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                    contentPadding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                    selectedTileColor: const Color.fromARGB(255, 233, 191, 24),
                    hoverColor: const Color.fromARGB(255, 233, 191, 24),
                  ),*/
                  const SizedBox(
                    height: 20,
                  ),
                  ListTile(
                    onTap: () {
                      if (token != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const NonResidentsHome()),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreenPolice()),
                        );
                      }
                    },
                    leading: const Icon(
                      Icons.contact_emergency_rounded,
                      color: Config.colorPrimary,
                      size: 25,
                    ),
                    trailing: const Icon(
                      Icons.chevron_right_rounded,
                      color: Color.fromARGB(255, 233, 191, 24),
                      size: 30,
                    ),
                    title: const Text(
                      'الدخول عبر الحدود البرية',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                    contentPadding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                    selectedTileColor: const Color.fromARGB(255, 233, 191, 24),
                    hoverColor: const Color.fromARGB(255, 233, 191, 24),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ListTile(
                    onTap: () {
                      if (token != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CitizenHome()),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreenPolice()),
                        );
                      }
                    },
                    leading: const Icon(
                      Icons.fact_check_rounded,
                      color: Config.colorPrimary,
                      size: 25,
                    ),
                    trailing: const Icon(
                      Icons.chevron_right_rounded,
                      color: Color.fromARGB(255, 233, 191, 24),
                      size: 30,
                    ),
                    title: const Text(
                      'الخروج عبر الحدود البرية',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                    contentPadding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                    selectedTileColor: const Color.fromARGB(255, 233, 191, 24),
                    hoverColor: const Color.fromARGB(255, 233, 191, 24),
                  ),
                  user?.role != 'admin'
                      ? SizedBox(
                          height: 0.1,
                        )
                      : Padding(
                          padding: EdgeInsets.only(right: 50, top: 15),
                          child: ListTile(
                            onTap: () async {
                              if (token != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const GestionComptesHome()),
                                );
                                //Provider.of<AuthProvider>(context, listen: false).logout();
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginScreenPolice()),
                                );
                              }
                            },
                            leading: Icon(
                              Icons.edit,
                              color: Config.colorPrimary,
                            ),
                            tileColor: Color.fromARGB(255, 60, 172, 227),
                            title: const Text(
                              'تسيير الحسابات',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Config.colorPrimary),
                            ),
                            contentPadding:
                                const EdgeInsets.fromLTRB(0, 0, 10, 0),
                            selectedTileColor:
                                const Color.fromARGB(255, 233, 191, 24),
                            hoverColor: const Color.fromARGB(255, 233, 191, 24),
                          )),
                  Padding(
                      padding: EdgeInsets.only(right: 50, top: 0),
                      child: ListTile(
                        onTap: () async {
                          Provider.of<AuthProvider>(context, listen: false)
                              .logout();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const LoginScreenPolice()),
                          );
                        },
                        leading: Icon(
                          Icons.logout,
                          color: Color.fromARGB(255, 154, 29, 7),
                        ),
                        tileColor: Color.fromARGB(255, 41, 116, 157),
                        title: const Text(
                          'تسجيل الخروج',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 154, 29, 7)),
                        ),
                        contentPadding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                        selectedTileColor:
                            const Color.fromARGB(255, 233, 191, 24),
                        hoverColor: const Color.fromARGB(255, 233, 191, 24),
                      )),
                ],
              ),
            ),
          ));
    }
    return GestureDetector(
      onTap: () {
        setState(() {
          Provider.of<AuthProvider>(context, listen: false).sideMenu = true;
        });
      },
      child: Container(
        width: screenWidth * 0.03,
        height: screenHeight * 1,
        color: Config.colorPrimary,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
                onPressed: () {
                  setState(() {
                    Provider.of<AuthProvider>(context, listen: false).sideMenu =
                        true;
                  });
                },
                icon: Icon(
                  Icons.auto_awesome_motion,
                  color: Color.fromARGB(255, 255, 255, 255),
                ))
          ],
        ),
      ),
    );
  }
}
