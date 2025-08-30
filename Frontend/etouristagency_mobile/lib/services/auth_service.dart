import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  late final String _controllerUrL;
  final storage = FlutterSecureStorage();
  String key = "user_data";

  AuthService() {
    var baseUrl = String.fromEnvironment(
      "baseUrl",
      defaultValue: "http://10.0.2.2:5001",
    );

    _controllerUrL = "${baseUrl}/api/User";
  }

  Future storeCredetials(String username, String password) async {
    var credentialsBytes = utf8.encode("${username}:${password}");
    var credentialsBase64String = base64Encode(credentialsBytes);
    var basicKey = "Basic ${credentialsBase64String}";

    var userData = UserData(basicKey);

    await storage.write(key: key, value: jsonEncode(userData.toJson()));
  }

  Future clearCredentials() async {
    await storage.delete(key: key);
  }

  Future storeUserId(String userId) async {
    var userDataString = await storage.read(key: key);

    if (userDataString == null) return;

    var userDataJson = jsonDecode(userDataString);
    var userData = UserData.fromJson(userDataJson);

    userData.id = userId;
    userDataJson = userData.toJson();

    await storage.write(key: key, value: jsonEncode(userDataJson));
  }

  Future<String> getBasicKey() async {
    var userDataString = await storage.read(key: key);

    if (userDataString == null) return "";
    var userDataJson = jsonDecode(userDataString);

    return UserData.fromJson(userDataJson).base64Key;
  }

  Future<String?> getUserId() async {
    var userDataString = await storage.read(key: key);

    if (userDataString == null) return null;
    var userDataJson = jsonDecode(userDataString);

    return UserData.fromJson(userDataJson).id;
  }

  Future<bool> areCredentialsValid() async {
    if ((await getBasicKey()) == "") return false;

    var url = Uri.parse('${_controllerUrL}/me');
    var response = await http.get(
      url,
      headers: {"Authorization": (await getBasicKey())},
    );

    if (response.statusCode == 401) {
      await clearCredentials();
      return false;
    }

    return true;
  }
}

class UserData {
  String base64Key;
  String? id;

  UserData(this.base64Key, {this.id});

  Map<String, dynamic> toJson() {
    return {"id": id, "base64Key": base64Key};
  }

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(json["base64Key"], id: json["id"]);
  }
}
