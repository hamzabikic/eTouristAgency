import 'dart:convert';

import 'package:etouristagency_desktop/models/user/user.dart';

class AuthConfig {
  static String? username;
  static String? password;
  static User? user;

  static String getAuthorizationHeader() {
    return "Basic ${base64Encode(utf8.encode("${username}:${password}"))}";
  }

  static void clearData() {
    username = null;
    password = null;
    user = null;
  }

  static bool isAuthenticated() {
    return user != null;
  }
}