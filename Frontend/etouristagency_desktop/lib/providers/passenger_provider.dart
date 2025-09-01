import 'package:etouristagency_desktop/helpers/auth_navigation_helper.dart';
import 'package:etouristagency_desktop/models/passenger/passenger_document.dart';
import 'package:etouristagency_desktop/models/passenger/passenger_list_document.dart';
import 'package:etouristagency_desktop/services/auth_service.dart';
import 'package:http/http.dart' as http;

class PassengerProvider {
  late final String controllerUrl;
  late final AuthService authService;

  PassengerProvider() {
    const baseUrl = String.fromEnvironment(
      "baseUrl",
      defaultValue: "https://localhost:5000",
    );

    controllerUrl = "${baseUrl}/api/passenger";
    authService = AuthService();
  }

  Future<PassengerDocument> getPassengerDocument(String passengerId) async {
    var url = Uri.parse("${controllerUrl}/${passengerId}/document");

    var response = await http.get(
      url,
      headers: {"Authorization": (await authService.getBasicKey())},
    );

    if (response.statusCode == 401) {
      await AuthNavigationHelper.handleUnauthorized();
      return PassengerDocument(null, null);
    }

    if (response.statusCode != 200) {
      throw Exception("Greška prilikom dohvatanja dokumenta: ${response.body}");
    }

    return PassengerDocument(
      response.headers["documentname"],
      response.bodyBytes,
    );
  }

  Future<PassengerListDocument> getDocumentOfPassegersByOfferId(
    String offerId,
  ) async {
    var url = Uri.parse("${controllerUrl}/${offerId}/passengers-document");

    var response = await http.get(
      url,
      headers: {"Authorization": (await authService.getBasicKey())},
    );

    if (response.statusCode == 401) {
      await AuthNavigationHelper.handleUnauthorized();
      return PassengerListDocument(null, null);
    }

    if (response.statusCode != 200) {
      throw Exception("Greška prilikom dohvatanja dokumenta: ${response.body}");
    }

    return PassengerListDocument(response.bodyBytes, response.headers["documentname"]);
  }
}
