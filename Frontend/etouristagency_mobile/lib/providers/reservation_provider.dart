import 'dart:convert';

import 'package:etouristagency_mobile/models/paginated_list.dart';
import 'package:etouristagency_mobile/models/reservation/my_reservation.dart';
import 'package:etouristagency_mobile/models/reservation/reservation.dart';
import 'package:etouristagency_mobile/models/reservation/reservation_payment_info.dart';
import 'package:etouristagency_mobile/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class ReservationProvider extends BaseProvider<Reservation> {
  ReservationProvider() : super("Reservation");

  @override
  Reservation jsonToModel(Map<String, dynamic> json) {
    return Reservation.fromJson(json);
  }

  Future<PaginatedList<MyReservation>> getAllForCurrentUser(
    Map<String, dynamic> filters,
  ) async {
    var queryStrings = getQueryStrings(filters);
    var url = Uri.parse("${controllerUrl}/me?${queryStrings}");

    var response = await http.get(
      url,
      headers: {
        "Authorization": (await authService.getBasicKey())!,
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Dogodila se greška: ${response.body}");
    }

    var json = jsonDecode(response.body);
    return PaginatedList(
      (json["listOfRecords"] as List)
          .map((e) => MyReservation.fromJson(e))
          .toList(),
      json["totalPages"],
    );
  }

  Future cancelReservation(String id) async {
    var url = Uri.parse("${controllerUrl}/${id}/cancellation");

    var response = await http.patch(
      url,
      headers: {
        "Authorization": (await authService.getBasicKey())!,
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        "Dogodila se greška prilikom otkazivanja rezervacije: ${response.body}",
      );
    }
  }

  Future<ReservationPaymentInfo> getReservationPaymentDocument(
    String reservationPaymentId,
  ) async {
    var url = Uri.parse(
      "${controllerUrl}/${reservationPaymentId}/payment-document",
    );

    var response = await http.get(
      url,
      headers: {"Authorization": (await authService.getBasicKey())!},
    );

    if (response.statusCode != 200)
      throw Exception(
        "Dogodila se greška prilikom preuzimanja dokumenta: ${response.body}",
      );

    return ReservationPaymentInfo(
      response.bodyBytes,
      response.headers["documentname"],
    );
  }
}
