import 'package:etouristagency_mobile/main.dart';
import 'package:etouristagency_mobile/screens/login_screen.dart';
import 'package:flutter/material.dart';

class AuthNavigationHelper {
  static bool _hasRedirectedToLogin = false;

  static bool get hasRedirectedToLogin => _hasRedirectedToLogin;

  static Future<void> handleUnauthorized() async {
    if (_hasRedirectedToLogin) {
      return;
    }

    _hasRedirectedToLogin = true;

    await navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => LoginScreen(isLoggedOut: true)),
      (route) => false,
    );
  }

  static void resetRedirectFlag() {
    _hasRedirectedToLogin = false;
  }
}
