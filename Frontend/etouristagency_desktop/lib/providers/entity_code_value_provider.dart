import 'dart:convert';

import 'package:etouristagency_desktop/config/app_config.dart';
import 'package:etouristagency_desktop/helpers/auth_navigation_helper.dart';
import 'package:etouristagency_desktop/models/entity_code_value/entity_code_value.dart';
import 'package:etouristagency_desktop/services/auth_service.dart';
import 'package:http/http.dart' as http;

class EntityCodeValueProvider {
  late final String controllerUrl;
  late final AuthService authService;

  EntityCodeValueProvider() {
    const baseUrl = String.fromEnvironment(
      "baseUrl",
      defaultValue: AppConfig.apiBaseUrl,
    );
    controllerUrl = "${baseUrl}/api/entitycodevalue";
    authService = AuthService();
  }

  Future<List<EntityCodeValue>> GetOfferStatusList() async {
    var url = Uri.parse("${controllerUrl}/offer-status");
    var response = await http.get(
      url,
      headers: {
        "Authorization": (await authService.getBasicKey())!,
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 401) {
      await AuthNavigationHelper.handleUnauthorized();
      return [];
    }

    if (response.statusCode != 200) {
      throw Exception("Neuspješno učitavanje statusa ponude: ${response.body}");
    }

    var offerStatusList = (jsonDecode(response.body) as List)
        .map((x) => EntityCodeValue.fromJson(x))
        .toList();
    return offerStatusList;
  }

  Future<List<EntityCodeValue>> GetBoardTypeList() async {
    var url = Uri.parse("${controllerUrl}/board-type");
    var response = await http.get(
      url,
      headers: {
        "Authorization": (await authService.getBasicKey())!,
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 401) {
      await AuthNavigationHelper.handleUnauthorized();
      return [];
    }

    if (response.statusCode != 200) {
      throw Exception("Neuspješno učitavanje statusa ponude: ${response.body}");
    }

    var offerStatusList = (jsonDecode(response.body) as List)
        .map((x) => EntityCodeValue.fromJson(x))
        .toList();
    return offerStatusList;
  }

  Future<List<EntityCodeValue>> GetReservationStatusList() async {
    var url = Uri.parse("${controllerUrl}/reservation-status");
    var response = await http.get(
      url,
      headers: {
        "Authorization": (await authService.getBasicKey())!,
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 401) {
      await AuthNavigationHelper.handleUnauthorized();
      return [];
    }

    if (response.statusCode != 200) {
      throw Exception(
        "Neuspješno učitavanje statusa rezervacije: ${response.body}",
      );
    }

    var offerStatusList = (jsonDecode(response.body) as List)
        .map((x) => EntityCodeValue.fromJson(x))
        .toList();
    return offerStatusList;
  }

  Future addBoardType(Map<String, dynamic> json) async {
    var url = Uri.parse("${controllerUrl}/board-type");
    var response = await http.post(
      url,
      headers: {
        "Authorization": (await authService.getBasicKey())!,
        "Content-Type": "application/json",
      },
      body: jsonEncode(json),
    );

    if (response.statusCode == 401) {
      await AuthNavigationHelper.handleUnauthorized();
      return;
    }

    if (response.statusCode == 200) {
      return;
    }

    throw Exception(
      "Dogodila se greška prilikom dodavanja tipa usluge: ${response.body}",
    );
  }

  Future addReservationStatus(
    Map<String, dynamic> json,
  ) async {
    var url = Uri.parse("${controllerUrl}/reservation-status");
    var response = await http.post(
      url,
      headers: {
        "Authorization": (await authService.getBasicKey())!,
        "Content-Type": "application/json",
      },
      body: jsonEncode(json),
    );

    if (response.statusCode == 401) {
      await AuthNavigationHelper.handleUnauthorized();
      return;
    }

    if (response.statusCode == 200) {
      return;
    }

    throw Exception(
      "Dogodila se greška prilikom dodavanja statusa rezervacije: ${response.body}",
    );
  }

  Future update(String id, Map<String, dynamic> json) async {
    var url = Uri.parse("${controllerUrl}/${id}");
    var response = await http.put(
      url,
      headers: {
        "Authorization": (await authService.getBasicKey())!,
        "Content-Type": "application/json",
      },
      body: jsonEncode(json),
    );

    if (response.statusCode == 401) {
      await AuthNavigationHelper.handleUnauthorized();
      return;
    }

    if (response.statusCode != 200) {
      throw Exception("Nije uspjelo uređivanje ${response.body}");
    }
  }
}
