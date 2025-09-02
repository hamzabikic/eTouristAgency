import 'dart:convert';

import 'package:etouristagency_mobile/config/app_config.dart';
import 'package:etouristagency_mobile/services/auth_service.dart';
import 'package:http/http.dart' as http;

class UserFirebaseTokenProvider {
  late final String controllerUrl;
  late final AuthService authService;

  UserFirebaseTokenProvider() {
    var baseUrl = String.fromEnvironment(
      "baseUrl",
      defaultValue: AppConfig.apiBaseUrl,
    );

    controllerUrl = "${baseUrl}/api/UserFirebaseToken";
    authService = AuthService();
  }

  Future add(Map<String, dynamic> requestModel) async {
    var url = Uri.parse(controllerUrl);

    var response = await http.post(
      url,
      headers: {
        "Authorization": (await authService.getBasicKey()),
        "Content-Type": "application/json",
      },
      body: jsonEncode(requestModel),
    );

    if (response.statusCode != 200)
      throw Exception("Dogodila se greška: ${response.body}");
  }

  Future update(Map<String, dynamic> requestModel) async {
    var url = Uri.parse(controllerUrl);

    var response = await http.patch(
      url,
      headers: {
        "Authorization": (await authService.getBasicKey()),
        "Content-Type": "application/json",
      },
      body: jsonEncode(requestModel),
    );

    if (response.statusCode != 200)
      throw Exception("Dogodila se greška: ${response.body}");
  }

  Future delete(String firebaseToken) async {
    var url = Uri.parse("${controllerUrl}?firebaseToken=${firebaseToken}");

    var response = await http.delete(
      url,
      headers: {
        "Authorization": (await authService.getBasicKey()),
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Dogodila se greška: ${response.body}");
    }
  }
}
