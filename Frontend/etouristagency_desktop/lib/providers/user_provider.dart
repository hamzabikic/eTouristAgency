import 'dart:convert';

import 'package:etouristagency_desktop/config/auth_config.dart';
import 'package:etouristagency_desktop/models/paginated_list.dart';
import 'package:etouristagency_desktop/models/user/user.dart';
import 'package:etouristagency_desktop/providers/base_provider.dart';
import 'package:http/http.dart' as http;

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

  @override
  User jsonToModel(json) {
    return User.fromJson(json);
  }
}
