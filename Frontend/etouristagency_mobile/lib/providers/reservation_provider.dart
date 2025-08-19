import 'package:etouristagency_mobile/models/reservation/reservation.dart';
import 'package:etouristagency_mobile/providers/base_provider.dart';

class ReservationProvider extends BaseProvider<Reservation>{
  ReservationProvider(): super("Reservation");

  @override Reservation jsonToModel(Map<String, dynamic> json) {
    return Reservation.fromJson(json);
  }
}