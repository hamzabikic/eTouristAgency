import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final storage = FlutterSecureStorage();
  String key = "basic_key";

  Future storeCredentials(String username, String password) async {
    var credentialsBytes = utf8.encode("${username}:${password}");
    var credentialsBase64String = base64Encode(credentialsBytes);
    var basicKey = "Basic ${credentialsBase64String}";

    await storage.write(key: key, value: basicKey);
  }

  Future clearCredentials() async {
    await storage.delete(key: key);
  }

  Future<String?> getBasicKey() async {
    return await storage.read(key: key);
  }

  Future<bool> isLoged() async {
    return (await getBasicKey()) != null;
  }
}
