import 'package:bawabba/core/models/user.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  String? _token;

  User? get user => _user;
  String? get token => _token;

  set token(String? token) {
    _token = token;
    notifyListeners(); // Notify listeners about the token change
  }

  set user(User? user) {
    _user = user;
    notifyListeners(); // Notify listeners about the token change
  }

  // Method to clear the token
  void logout() {
    _token = null;
    notifyListeners();
  }
}
