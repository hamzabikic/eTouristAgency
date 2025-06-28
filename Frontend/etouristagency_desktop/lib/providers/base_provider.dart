import 'dart:convert';

import 'package:etouristagency_desktop/config/auth_config.dart';
import 'package:http/http.dart' as http;

abstract class BaseProvider{
  late final String controllerUrl;
  
  BaseProvider(String controller){
    var baseUrl = String.fromEnvironment("baseUrl", defaultValue:  "https://localhost:5000");
    controllerUrl = "${baseUrl}/api/${controller}";
  }

  Future<Map<String, dynamic>> getById(String id) async {
      Uri url = Uri.parse("${controllerUrl}/$id");

      var response = await http.get(url, headers: {"Authorization": AuthConfig.getAuthorizationHeader(),
                                                   "Content-Type": "application/json"});

      if(response.statusCode == 401) throw Exception(response.body);

      return jsonDecode(response.body);
  }
}