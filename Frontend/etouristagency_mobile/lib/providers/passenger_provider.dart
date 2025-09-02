import 'package:etouristagency_mobile/config/app_config.dart';
import 'package:etouristagency_mobile/helpers/auth_navigation_helper.dart';
import 'package:etouristagency_mobile/models/passenger/passenger_document.dart';
import 'package:etouristagency_mobile/services/auth_service.dart';
import 'package:http/http.dart' as http;

class PassengerProvider {
  late final String controllerUrl;
  late final AuthService authService;

  PassengerProvider() {
    var baseUrl = String.fromEnvironment(
      "baseUrl",
      defaultValue: AppConfig.apiBaseUrl,
    );

    controllerUrl = "${baseUrl}/api/passenger";
    authService = AuthService();
  }

  Future<PassengerDocument> getDocumentById(String id) async {
    var url = Uri.parse("${controllerUrl}/${id}/document");

    var response = await http.get(
      url,
      headers: {"Authorization": (await authService.getBasicKey())},
    );

    if (response.statusCode == 401) {
      await AuthNavigationHelper.handleUnauthorized();
      return PassengerDocument(null, null);
    }

    if (response.statusCode != 200)
      throw Exception(
        "Greška prilikom preuzimanja dokumenta :${response.body}",
      );

    return PassengerDocument(
      response.headers["documentname"],
      (await response.bodyBytes),
    );
  }
}
