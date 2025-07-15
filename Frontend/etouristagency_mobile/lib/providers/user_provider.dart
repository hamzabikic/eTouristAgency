import 'dart:convert';
import 'package:etouristagency_mobile/models/user/user.dart';
import 'package:http/http.dart' as http;
import 'package:etouristagency_mobile/config/auth_config.dart';
import 'package:etouristagency_mobile/providers/base_provider.dart';

class UserProvider extends BaseProvider<User> {
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

  Future<bool> exists(String email, String username) async {
    var url = Uri.parse(
      "${super.controllerUrl}/Exists?email=${email}&username=${username}",
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

  Future verify(String verificationKey) async {
    var url = Uri.parse(
      "${controllerUrl}/verify?verificationKey=${verificationKey}",
    );
    var response = await http.patch(
      url,
      headers: {
        "Authorization": AuthConfig.getAuthorizationHeader(),
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode != 200) throw Exception(response.body);
  }

  Future resetPassword(Map<String, dynamic> requestModel) async {
    var url = Uri.parse("${controllerUrl}/reset-password");

    var response = await http.patch(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(requestModel),
    );

    if (response.statusCode != 200) {
      throw Exception(response.body);
    }
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
  User jsonToModel(Map<String, dynamic> json) {
    return User.fromJson(json);
  }
}
