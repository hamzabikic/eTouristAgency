import 'dart:convert';

import 'package:etouristagency_desktop/models/reservation/reservation.dart';
import 'package:etouristagency_desktop/models/reservation/reservation_payment_info.dart';
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

    if (response.statusCode != 200) {
      throw Exception("Dogodila se greška: ${response.body}");
    }
  }

  Future<ReservationPaymentInfo> getPaymentDocument(String reservationPaymentId) async {
    var url = Uri.parse(
      "${controllerUrl}/${reservationPaymentId}/payment-document",
    );

    var response = await http.get(
      url,
      headers: {"Authorization": (await authService.getBasicKey())!},
    );

    if (response.statusCode != 200)
      throw Exception("Greška pri učitavanju dokumenta: ${response.body}");

    return ReservationPaymentInfo(response.bodyBytes, response.headers["documentname"]);
  }
}
