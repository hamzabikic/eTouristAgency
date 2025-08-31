import 'package:etouristagency_mobile/helpers/auth_navigation_helper.dart';
import 'package:etouristagency_mobile/services/auth_service.dart';
import 'package:http/http.dart' as http;

class VerificationCodeProvider {
  late final String _controllerUrl;
  late final AuthService authService;

  VerificationCodeProvider() {
    var baseUrl = String.fromEnvironment(
      "baseUrl",
      defaultValue: "http://10.0.2.2:5001",
    );

    _controllerUrl = "${baseUrl}/api/VerificationCode";
    authService = AuthService();
  }

  Future addEmailVerification() async {
    var url = Uri.parse("${_controllerUrl}/email-verification");

    var response = await http.post(
      url,
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
      throw Exception(
        "Dosegli ste limit. U 24 sata moguće je poslati maksimalno 5 puta zahtjev za verifikaciju.",
      );
    }
  }

  Future addResetPasswordVerification(String email) async {
    var url = Uri.parse("${_controllerUrl}/reset-password?email=${email}");

    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode != 200) {
      throw Exception(response.body);
    }
  }

  Future<bool> resetPasswordVerificationCodeExists(
    String verificationKey,
  ) async {
    var url = Uri.parse(
      "${_controllerUrl}/reset-password/exists?verificationKey=${verificationKey}",
    );

    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode != 200) {
      throw Exception(response.body);
    }

    return bool.parse(response.body);
  }
}
