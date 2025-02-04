import 'package:bawabba/core/services/auth_provider.dart';
import 'package:bawabba/ui/widgets/non_residents/add_nonResident_form.dart';
import 'package:bawabba/ui/widgets/non_residents/nonResident_table1.dart';
import 'package:bawabba/ui/widgets/non_residents/nonResident_table2.dart';
import 'package:bawabba/ui/widgets/non_residents/nonResidents_actions.dart';
import 'package:bawabba/ui/widgets/side_menu2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

class NonResidentsHome extends StatefulWidget {
  const NonResidentsHome({
    super.key,
  });

  @override
  State<NonResidentsHome> createState() => _NonResidentsHomeState();
}

class _NonResidentsHomeState extends State<NonResidentsHome> {
  // ignore: unused_field

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Row(
        children: <Widget>[
          SideMenu2(),
          NonResidentsScreen(),
          //LoginPage()
        ],
      ),

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class NonResidentsScreen extends StatefulWidget {
  const NonResidentsScreen({
    super.key,
  });

  @override
  State<NonResidentsScreen> createState() => _NonResidentsScreenState();
}

class _NonResidentsScreenState extends State<NonResidentsScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final sideMenu = Provider.of<AuthProvider>(context, listen: true).sideMenu;

    return Column(
      children: [
        Container(
          width: sideMenu ? screenWidth * 0.815 : screenWidth * 0.97,
          height: screenHeight,
          color: const Color.fromARGB(255, 239, 242, 243),
          child: const Stack(
            children: <Widget>[
              Positioned(
                top: 11,
                right: 20,
                child: Text(
                  'الصفحات / الدخول عبر الحدود البرية ',
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
              Positioned(
                top: 36,
                right: 30,
                child: Text(
                  ' تسيير الدخول عبر الحدود البرية',
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
              SizedBox(
                height: 05,
              ),
              Positioned.fill(
                right: 0,
                top: 100,
                bottom: 30,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AddNonResidentForm(),
                      SizedBox(height: 20),
                      NonResidentsActions(),
                      SizedBox(height: 20),
                      NonResidentsTable2(),
                      SizedBox(height: 20),
                      NonResidentTable1(),
                    ],
                  ),
                ),
              ),
              Positioned(
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
              Positioned(
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
    );
  }
}
