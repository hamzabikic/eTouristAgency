import 'dart:convert';

import 'package:etouristagency_desktop/config/auth_config.dart';
import 'package:etouristagency_desktop/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class UserProvider extends BaseProvider {
  UserProvider() : super("User");

  Future<Map<String, dynamic>> getMe() async {
    var url = Uri.parse("${super.controllerUrl}/Me");
    var response = await http.get(
      url,
      headers: {
        "Authorization": AuthConfig.getAuthorizationHeader(),
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 401)
      throw Exception("Uneseno korisničko ime ili lozinka su netačni.");
    if (response.statusCode != 200) throw Exception(response.body);

    return jsonDecode(response.body);
  }
}