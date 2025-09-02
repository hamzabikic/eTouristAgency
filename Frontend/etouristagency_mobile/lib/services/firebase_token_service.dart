import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FirebaseTokenService {
  final storage = FlutterSecureStorage();
  String key = "firebase_token";

  Future storeToken(String token) async {
    await storage.write(key: key, value: token);
  }

  Future removeToken() async {
    await storage.delete(key: key);
  }

  Future<String?> getToken() async {
    return await storage.read(key: key);
  }
}