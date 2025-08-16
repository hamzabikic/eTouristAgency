import 'dart:convert';
import 'dart:core';
import 'package:etouristagency_desktop/models/paginated_list.dart';
import 'package:etouristagency_desktop/services/auth_service.dart';
import 'package:http/http.dart' as http;

abstract class BaseProvider<TResponseModel> {
  late final String controllerUrl;
  late final AuthService authService;

  BaseProvider(String controller) {
    const baseUrl = String.fromEnvironment(
      "baseUrl",
      defaultValue: "https://localhost:5000",
    );
    controllerUrl = "${baseUrl}/api/${controller}";
    authService = AuthService();
  }

  Future<TResponseModel> getById(String id) async {
    Uri url = Uri.parse("${controllerUrl}/$id");

    var response = await http.get(
      url,
      headers: {
        "Authorization": (await authService.getBasicKey())!,
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode != 200) throw Exception(response.body);

    return jsonToModel(jsonDecode(response.body));
  }

  Future add(Map<String, dynamic> insertModel) async {
    var url = Uri.parse(controllerUrl);
    var response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": (await authService.getBasicKey())!,
      },
      body: jsonEncode(insertModel),
    );

    if (response.statusCode != 200)
      throw Exception("Dogodila se greska: ${response.body}");
  }

  Future update(String id, Map<String, dynamic> updateModel) async {
    var url = Uri.parse("${controllerUrl}/${id}");
    var response = await http.put(
      url,
      headers: {
        "Authorization": (await authService.getBasicKey())!,
        "Content-Type": "application/json",
      },
      body: jsonEncode(updateModel),
    );

    if (response.statusCode != 200)
      throw Exception("Dogodila se greska: ${response.body}");
  }

  Future<PaginatedList<TResponseModel>> getAll(
    Map<String, dynamic> filters,
  ) async {
    var queryStrings = getQueryStrings(filters);
    Uri url = Uri.parse("${controllerUrl}${queryStrings}");

    var response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": (await authService.getBasicKey())!,
      },
    );

    if (response.statusCode != 200)
      throw Exception("Nije uspjelo dohvatanje podataka: ${response.body}");

    return jsonToPaginatedList(jsonDecode(response.body));
  }

  String getQueryStrings(Map<String, dynamic> filters) {
    String queryStrings = "?";

    for (var key in filters.keys) {
      queryStrings += "${key}=${filters[key]}&";
    }

    return queryStrings;
  }

  PaginatedList<TResponseModel> jsonToPaginatedList(dynamic json) {
    return PaginatedList<TResponseModel>(
      (json["listOfRecords"] as List).map((e) => jsonToModel(e)).toList(),
      json["totalPages"],
    );
  }

  TResponseModel jsonToModel(dynamic json) {
    throw Exception("Method is not implemented.");
  }
}
