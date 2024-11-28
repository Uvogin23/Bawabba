import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:window_manager/window_manager.dart';
import 'package:bawabba/core/services/card_stats.dart';
import 'package:bawabba/core/models/user.dart';
import 'package:bawabba/core/services/auth_provider.dart';
import 'package:bawabba/main.dart';

import 'package:provider/provider.dart';

class EmployeeTable extends StatefulWidget {
  const EmployeeTable({Key? key}) : super(key: key);

  @override
  State<EmployeeTable> createState() => _EmployeeTable();
}

class _EmployeeTable extends State<EmployeeTable> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1200,
      height: 500,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 128, 171, 214),
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
    );
  }
}
