import 'package:etouristagency_mobile/config/app_config.dart';
import 'package:etouristagency_mobile/helpers/auth_navigation_helper.dart';
import 'package:etouristagency_mobile/models/paginated_list.dart';
import 'package:etouristagency_mobile/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class BaseProvider<TResponseModel> {
  late final String controllerUrl;
  late final AuthService authService;

  BaseProvider(String controller) {
    var baseUrl = String.fromEnvironment(
      "baseUrl",
      defaultValue: AppConfig.apiBaseUrl,
    );
    controllerUrl = "${baseUrl}/api/${controller}";
    authService = AuthService();
  }

  Future<PaginatedList<TResponseModel>> getAll(
    Map<String, dynamic> filters,
  ) async {
    String queryStrings = getQueryStrings(filters);
    Uri url = Uri.parse("${controllerUrl}?${queryStrings}");

    var response = await http.get(
      url,
      headers: {
        "Authorization": (await authService.getBasicKey())!,
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 401) {
      await AuthNavigationHelper.handleUnauthorized();
      return PaginatedList([], 0);
    }

    if (response.statusCode != 200) {
      throw Exception("Dogodila se greška: ${response.body}");
    }

    var json = jsonDecode(response.body);

    return PaginatedList<TResponseModel>(
      (json["listOfRecords"] as List).map((e) => jsonToModel(e)).toList(),
      json["totalPages"],
    );
  }

  Future<Map<String, dynamic>> getById(String id) async {
    Uri url = Uri.parse("${controllerUrl}/$id");

    var response = await http.get(
      url,
      headers: {
        "Authorization": (await authService.getBasicKey())!,
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 401) {
      await AuthNavigationHelper.handleUnauthorized();
      return {};
    }

    if (response.statusCode != 200) {
      throw Exception("Dogodila se greška: ${response.body}");
    }

    return jsonDecode(response.body);
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

    if (response.statusCode == 401) {
      await AuthNavigationHelper.handleUnauthorized();
      return;
    }

    if (response.statusCode != 200) {
      throw Exception("Dogodila se greška: ${response.body}");
    }
  }

  Future add(Map<String, dynamic> insertModel) async {
    Uri url = Uri.parse(controllerUrl);

    var response = await http.post(
      url,
      body: jsonEncode(insertModel),
      headers: {
        "Authorization": (await authService.getBasicKey())!,
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 401) {
      await AuthNavigationHelper.handleUnauthorized();
      return;
    }

    if (response.statusCode != 200) {
      throw Exception("Dogodila se greška: ${response.body}");
    }
  }

  String getQueryStrings(Map<String, dynamic> filters) {
    String queryStrings = "";

    for (var item in filters.keys) {
      queryStrings += "$item=${filters[item]}&";
    }

    return queryStrings;
  }

  TResponseModel jsonToModel(Map<String, dynamic> json) {
    throw Exception("This method is not implemented.");
  }
}
