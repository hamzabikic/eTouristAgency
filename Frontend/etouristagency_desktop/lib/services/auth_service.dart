import 'dart:convert';
import 'package:etouristagency_desktop/config/app_config.dart';
import 'package:etouristagency_desktop/models/user/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService {
  late final String _controllerUrL;
  final storage = FlutterSecureStorage();
  String key = "auth_data";

  AuthService() {
    var baseUrl = String.fromEnvironment(
      "baseUrl",
      defaultValue: AppConfig.apiBaseUrl,
    );

    _controllerUrL = "${baseUrl}/api/User";
  }

  Future storeCredentials(String username, String password) async {
    var credentialsBytes = utf8.encode("${username}:${password}");
    var credentialsBase64String = base64Encode(credentialsBytes);
    var basicKey = "Basic ${credentialsBase64String}";

    var authData = AuthData(basicKey);

    await storage.write(key: key, value: jsonEncode(authData.toJson()));
  }

  Future clearCredentials() async {
    await storage.delete(key: key);
  }

  Future storeData(User userData) async {
    var authDataString = await storage.read(key: key);

    if (authDataString == null) return;

    var authDataJson = jsonDecode(authDataString);
    var authData = AuthData.fromJson(authDataJson);

    authData.userData = userData;
    authDataJson = authData.toJson();

    await storage.write(key: key, value: jsonEncode(authDataJson));
  }

  Future<User?> getUserData() async{
    var authDataString = await storage.read(key: key);

    if(authDataString == null) return null;

    var authDataJson = jsonDecode(authDataString);
    var authData =  AuthData.fromJson(authDataJson);

    return authData.userData;
  }

  Future<String> getBasicKey() async {
    var userDataString = await storage.read(key: key);

    if (userDataString == null) return "";
    var userDataJson = jsonDecode(userDataString);

    return AuthData.fromJson(userDataJson).base64Key;
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

class AuthData {
  String base64Key;
  User? userData;

  AuthData(this.base64Key, {this.userData});

  Map<String, dynamic> toJson() {
    return {"userData": userData?.toJson(), "base64Key": base64Key};
  }

  factory AuthData.fromJson(Map<String, dynamic> json) {
    return AuthData(
      json["base64Key"],
      userData: json["userData"] != null
          ? User.fromJson(json["userData"])
          : null,
    );
  }
}
