import 'dart:convert';

import 'package:etouristagency_desktop/models/reservation/reservation.dart';
import 'package:etouristagency_desktop/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class ReservationProvider extends BaseProvider<Reservation> {
  ReservationProvider() : super("Reservation");

  @override
  Reservation jsonToModel(json) {
    return Reservation.fromJson(json);
  }

  Future addPayment(String id, Map<String, dynamic> json) async {
    var url = Uri.parse("${controllerUrl}/${id}/payment");

    var response = await http.patch(
      url,
      headers: {
        "Authorization": (await authService.getBasicKey())!,
        "Content-Type": "application/json",
      },
      body: jsonEncode(json),
    );

    if(response.statusCode !=200) {
      throw Exception("Dogodila se greška: ${response.body}");
    }
  }
}
