import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:etouristagency_mobile/config/auth_config.dart';

abstract class BaseProvider<TResponseModel> {
  late final String controllerUrl;

  BaseProvider(String controller) {
    var baseUrl = String.fromEnvironment(
      "baseUrl",
      defaultValue: "http://10.0.2.2:5001",
    );
    controllerUrl = "${baseUrl}/api/${controller}";
  }

  Future<Map<String, dynamic>> getById(String id) async {
    Uri url = Uri.parse("${controllerUrl}/$id");

    var response = await http.get(
      url,
      headers: {
        "Authorization": AuthConfig.getAuthorizationHeader(),
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 401) throw Exception(response.body);

    return jsonDecode(response.body);
  }

  Future<TResponseModel> update(
    String id,
    Map<String, dynamic> updateModel,
  ) async {
    var url = Uri.parse("${controllerUrl}/${id}");
    var response = await http.put(
      url,
      headers: {
        "Authorization": AuthConfig.getAuthorizationHeader(),
        "Content-Type": "application/json",
      },
      body: jsonEncode(updateModel),
    );

    if (response.statusCode != 200) {
      throw Exception("Dogodila se greska: ${response.body}");
    }

    return jsonToModel(jsonDecode(response.body));
  }

  Future<TResponseModel> add(Map<String, dynamic> insertModel) async {
    Uri url = Uri.parse(controllerUrl);

    var response = await http.post(
      url,
      body: jsonEncode(insertModel),
      headers: {
        "Authorization": AuthConfig.getAuthorizationHeader(),
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      if (!response.body.isEmpty) {
        return jsonToModel(jsonDecode(response.body));
      } else {
        return jsonToModel({});
      }
    }

    throw Exception("Dogodila se greška: ${response.body}");
  }

  TResponseModel jsonToModel(Map<String, dynamic> json) {
    throw Exception("This method is not implemented.");
  }
}
