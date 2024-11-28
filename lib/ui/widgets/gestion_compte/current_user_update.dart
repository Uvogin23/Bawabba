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

class CurrentUserUpdate extends StatefulWidget {
  const CurrentUserUpdate({Key? key}) : super(key: key);

  @override
  State<CurrentUserUpdate> createState() => _CurrentUserUpdate();
}

class _CurrentUserUpdate extends State<CurrentUserUpdate> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1200,
      height: 500,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 68, 95, 122),
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
    );
  }
}
