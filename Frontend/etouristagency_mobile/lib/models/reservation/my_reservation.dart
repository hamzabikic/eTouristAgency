import 'package:etouristagency_mobile/models/entity_code_value/entity_code_value.dart';
import 'package:etouristagency_mobile/models/hotel/hotel.dart';
import 'package:etouristagency_mobile/models/offer/offer_image.dart';
import 'package:etouristagency_mobile/models/room_type/room_type.dart';
import 'package:intl/intl.dart';

class MyReservation {
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
  EntityCodeValue? reservationStatus;
  MyRoom? room;

  MyReservation(
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
    this.reservationStatus,
    this.room,
  );

  factory MyReservation.fromJson(Map<String, dynamic> json) {
    return MyReservation(
      json['id'],
      json['userId'],
      json["createdOn"] != null ? DateTime.parse(json['createdOn']) : null,
      json["modifiedOn"] != null ? DateTime.parse(json['modifiedOn']) : null,
      json['paidAmount'] != null
          ? (json['paidAmount'] as num).toDouble()
          : null,
      json['cancellationDate'] != null
          ? DateTime.parse(json['cancellationDate'])
          : null,
      json['reservationNo'],
      json['totalCost'] != null ? (json['totalCost'] as num).toDouble() : null,
      json['offerDiscountId'],
      json['reservationStatusId'],
      json['roomId'],
      json['reservationStatus'] != null
          ? EntityCodeValue.fromJson(json['reservationStatus'])
          : null,
      json['room'] != null ? MyRoom.fromJson(json['room']) : null,
    );
  }
}

class MyRoom {
  String? id;
  String? roomTypeId;
  String? offerId;
  double? pricePerPerson;
  double? childDiscount;
  int? quantity;
  String? shortDescription;
  RoomType? roomType;
  MyOffer? offer;

  MyRoom(
    this.id,
    this.roomTypeId,
    this.offerId,
    this.pricePerPerson,
    this.childDiscount,
    this.quantity,
    this.shortDescription,
    this.roomType,
    this.offer,
  );

  factory MyRoom.fromJson(Map<String, dynamic> json) {
    return MyRoom(
      json["id"],
      json["roomTypeId"],
      json["offerId"],
      json["pricePerPerson"] != null
          ? (json["pricePerPerson"] as num).toDouble()
          : null,
      json["childDiscount"] != null
          ? (json["childDiscount"] as num).toDouble()
          : null,
      json["quantity"],
      json["shortDescription"],
      json["roomType"] != null ? RoomType.fromJson(json["roomType"]) : null,
      json["offer"] != null ? MyOffer.fromJson(json["offer"]) : null,
    );
  }
}

class MyOffer {
  String? id;
  DateTime? tripStartDate;
  int? numberOfNights;
  DateTime? tripEndDate;
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
  OfferImage? offerImage;

  String get formattedStartDate =>
      DateFormat('dd.MM.yyyy').format(tripStartDate!);

  String get formattedEndDate => DateFormat('dd.MM.yyyy').format(tripEndDate!);

  MyOffer(
    this.id,
    this.tripStartDate,
    this.numberOfNights,
    this.tripEndDate,
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
    this.offerImage,
  );

  factory MyOffer.fromJson(Map<String, dynamic> json) {
    return MyOffer(
      json["id"],
      json["tripStartDate"] != null
          ? DateTime.parse(json["tripStartDate"])
          : null,
      json["numberOfNights"],
      json["tripEndDate"] != null ? DateTime.parse(json["tripEndDate"]) : null,
      json["carriers"],
      json["description"],
      json["firstPaymentDeadline"] != null
          ? DateTime.parse(json["firstPaymentDeadline"])
          : null,
      json["lastPaymentDeadline"] != null
          ? DateTime.parse(json["lastPaymentDeadline"])
          : null,
      json["offerNo"],
      json["departurePlace"],
      json["hotelId"],
      json["offerStatusId"],
      json["boardTypeId"],
      json["boardType"] != null
          ? EntityCodeValue.fromJson(json["boardType"])
          : null,
      json["hotel"] != null ? Hotel.fromJson(json["hotel"]) : null,
      json["offerImage"] != null
          ? OfferImage.fromJson(json["offerImage"])
          : null,
    );
  }
}
