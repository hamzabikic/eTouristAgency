import 'package:etouristagency_desktop/models/entity_code_value/entity_code_value.dart';
import 'package:etouristagency_desktop/models/hotel/hotel.dart';
import 'package:etouristagency_desktop/models/offer_discount/offer_discount.dart';
import 'package:etouristagency_desktop/models/room/room.dart';
import 'package:flutter/material.dart';

class Offer {
  String? id;
  DateTime? tripStartDate;
  DateTime? tripEndDate;
  int? numberOfNights;
  String? carriers;
  String? description;
  DateTime? firstPaymentDeadline;
  DateTime? lastPaymentDeadline;
  int? offerNo;
  String? departurePlace;
  String? hotelId;
  String? offerStatusId;
  String? boardTypeId;
  EntityCodeValue? boardType;
  Hotel? hotel;
  EntityCodeValue? offerStatus;
  List<OfferDiscount>? offerDiscounts;
  List<Room>? rooms;

  bool isReviewsButtonEnabled() {
    final now = DateUtils.dateOnly(DateTime.now());
    final endDate = DateUtils.dateOnly(tripEndDate!);

    return endDate.isBefore(now) || endDate.isAtSameMomentAs(now);
  }

  bool isReservationAndOfferEditEnabled() {
    final now = DateUtils.dateOnly(DateTime.now());
    final startDate = DateUtils.dateOnly(tripStartDate!);

    return now.isBefore(startDate);
  }

  Offer(
    this.id,
    this.tripStartDate,
    this.tripEndDate,
    this.numberOfNights,
    this.carriers,
    this.description,
    this.firstPaymentDeadline,
    this.lastPaymentDeadline,
    this.offerNo,
    this.departurePlace,
    this.hotelId,
    this.offerStatusId,
    this.boardTypeId,
    this.boardType,
    this.hotel,
    this.offerStatus,
    this.offerDiscounts,
    this.rooms,
  );

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      json["id"],
      DateTime.parse(json["tripStartDate"]),
      DateTime.parse(json["tripEndDate"]),
      json["numberOfNights"],
      json["carriers"],
      json["description"],
      DateTime.parse(json["firstPaymentDeadline"]),
      DateTime.parse(json["lastPaymentDeadline"]),
      json["offerNo"],
      json["departurePlace"],
      json["hotelId"],
      json["offerStatusId"],
      json["boardTypeId"],
      json["boardType"] == null
          ? null
          : EntityCodeValue.fromJson(json["boardType"]),
      json["hotel"] == null ? null : Hotel.fromJson(json["hotel"]),
      json["offerStatus"] == null
          ? null
          : EntityCodeValue.fromJson(json["offerStatus"]),
      json["offerDiscounts"] != null
          ? (json["offerDiscounts"] as List)
                .map((x) => OfferDiscount.fromJson(x))
                .toList()
          : null,
      json["rooms"] != null
          ? (json["rooms"] as List).map((x) => Room.fromJson(x)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "tripStartDate": tripStartDate,
      "tripEndDate": tripEndDate,
      "numberOfNights": numberOfNights?.toString(),
      "carriers": carriers,
      "description": description,
      "firstPaymentDeadline": firstPaymentDeadline,
      "lastPaymentDeadline": lastPaymentDeadline,
      "offerNo": offerNo?.toString(),
      "departurePlace": departurePlace,
      "hotelId": hotelId,
      "offerStatusId": offerStatusId,
      "boardTypeId": boardTypeId,
    };
  }
}
