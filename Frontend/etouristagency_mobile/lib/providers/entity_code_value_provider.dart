import 'dart:convert';
import 'package:etouristagency_mobile/helpers/auth_navigation_helper.dart';
import 'package:etouristagency_mobile/models/entity_code_value/entity_code_value.dart';
import 'package:etouristagency_mobile/services/auth_service.dart';
import 'package:http/http.dart' as http;

class EntityCodeValueProvider {
  late String controllerUrl;
  late final AuthService _authService;

  EntityCodeValueProvider() {
    const baseUrl = String.fromEnvironment(
      "baseUrl",
      defaultValue: "http://10.0.2.2:5001",
    );
    controllerUrl = "${baseUrl}/api/entitycodevalue";
    _authService = AuthService();
  }

  Future<List<EntityCodeValue>> getBoardTypes() async {
    var url = Uri.parse("${controllerUrl}/board-type");

    var response = await http.get(
      url,
      headers: {
        "Authorization": (await _authService.getBasicKey())!,
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 401) {
      await AuthNavigationHelper.handleUnauthorized();

      return [];
    }

    return (jsonDecode(response.body) as List)
        .map((e) => EntityCodeValue.fromJson(e))
        .toList();
  }
}
