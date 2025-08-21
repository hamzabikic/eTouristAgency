import 'package:etouristagency_mobile/models/entity_code_value/entity_code_value.dart';
import 'package:etouristagency_mobile/models/offer_discount/offer_discount.dart';
import 'package:etouristagency_mobile/models/passenger/passenger.dart';
import 'package:etouristagency_mobile/models/reservation/reservation_payment.dart';
import 'package:etouristagency_mobile/models/room/room.dart';
import 'package:etouristagency_mobile/models/user/user.dart';

class Reservation {
  String? id;
  String? userId;
  DateTime? createdOn;
  DateTime? modifiedOn;
  double? paidAmount;
  DateTime? cancellationDate;
  int? reservationNo;
  double? totalCost;
  String? offerDiscountId;
  String? reservationStatusId;
  String? roomId;
  Room? room;
  OfferDiscount? offerDiscount;
  List<Passenger>? passengers;
  EntityCodeValue? reservationStatus;
  List<ReservationPayment>? reservationPayments;
  User? user;
  String? note;

  Reservation(
    this.id,
    this.userId,
    this.createdOn,
    this.modifiedOn,
    this.paidAmount,
    this.cancellationDate,
    this.reservationNo,
    this.totalCost,
    this.offerDiscountId,
    this.reservationStatusId,
    this.roomId,
    this.room,
    this.offerDiscount,
    this.passengers,
    this.reservationStatus,
    this.reservationPayments,
    this.user,
    this.note
  );

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      json["id"],
      json["userId"],
      json["createdOn"] != null ? DateTime.parse(json["createdOn"]) : null,
      json["modifiedOn"] != null ? DateTime.parse(json["modifiedOn"]) : null,
      json["paidAmount"] != null
          ? (json["paidAmount"] as num).toDouble()
          : null,
      json["cancellationDate"] != null
          ? DateTime.parse(json["cancellationDate"])
          : null,
      json["reservationNo"],
      json["totalCost"] != null ? (json["totalCost"] as num).toDouble() : null,
      json["offerDiscountId"],
      json["reservationStatusId"],
      json["roomId"],
      json["room"] != null ? Room.fromJson(json["room"]) : null,
      json["offerDiscount"] != null
          ? OfferDiscount.fromJson(json["offerDiscount"])
          : null,
      json["passengers"] != null
          ? (json["passengers"] as List)
                .map((e) => Passenger.fromJson(e))
                .toList()
          : null,
      json["reservationStatus"] != null
          ? EntityCodeValue.fromJson(json["reservationStatus"])
          : null,
      json["reservationPayments"] != null ? (json["reservationPayments"] as List).map((e)=> ReservationPayment.fromJson(e)).toList() : null,
      json["user"] != null ? User.fromJson(json["user"]) : null,
      json["note"]
    );
  }
}
