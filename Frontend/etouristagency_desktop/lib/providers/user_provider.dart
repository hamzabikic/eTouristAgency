import 'dart:convert';

import 'package:etouristagency_desktop/config/auth_config.dart';
import 'package:etouristagency_desktop/models/user/user.dart';
import 'package:etouristagency_desktop/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class UserProvider extends BaseProvider<User> {
  UserProvider() : super("User");

  Future<Map<String, dynamic>> getMe() async {
    var url = Uri.parse("${super.controllerUrl}/me");
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

  Future<bool> exists(String email, String username) async {
    var url = Uri.parse(
      "${super.controllerUrl}/exists?email=${email}&username=${username}",
    );
    var response = await http.get(
      url,
      headers: {
        "Authorization": AuthConfig.getAuthorizationHeader(),
        "accept": "text/plain",
      },
    );

    if (response.statusCode != 200) throw Exception(response.body);

    return bool.parse(response.body);
  }

  Future verify(String userId) async {
    var url = Uri.parse("${controllerUrl}/${userId}/verify");
    var response = await http.patch(
      url,
      headers: {
        "Authorization": AuthConfig.getAuthorizationHeader(),
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode != 200) throw Exception(response.body);
  }

  Future resetPassword(String userId) async {
    var url = Uri.parse("${controllerUrl}/${userId}/reset-password");
    var response = await http.post(
      url,
      headers: {
        "Authorization": AuthConfig.getAuthorizationHeader(),
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode != 200) throw Exception(response.body);
  }

  Future deactivate(String userId) async {
    var url = Uri.parse("${controllerUrl}/${userId}/deactivate");
    var response = await http.patch(
      url,
      headers: {
        "Authorization": AuthConfig.getAuthorizationHeader(),
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode != 200) throw Exception(response.body);
  }

  @override
  User jsonToModel(json) {
    return User.fromJson(json);
  }
}
