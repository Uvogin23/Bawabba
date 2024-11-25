import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  String? _token;

  String? get token => _token;

  set token(String? token) {
    _token = token;
    notifyListeners(); // Notify listeners about the token change
  }

  // Method to clear the token
  void logout() {
    _token = null;
    notifyListeners();
  }
}
