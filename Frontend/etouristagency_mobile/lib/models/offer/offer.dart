import 'package:etouristagency_mobile/models/entity_code_value/entity_code_value.dart';
import 'package:etouristagency_mobile/models/hotel/hotel.dart';
import 'package:etouristagency_mobile/models/offer_discount/offer_discount.dart';
import 'package:etouristagency_mobile/models/room/room.dart';
import 'package:intl/intl.dart';

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
  bool? isFirstMinuteDiscountActive;
  bool? isLastMinuteDiscountActive;
  double? minimumPricePerPerson;
  int? remainingSpots;
  Hotel? hotel;
  EntityCodeValue? offerStatus;
  List<OfferDiscount>? offerDiscounts;
  List<Room>? rooms;

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
    this.isFirstMinuteDiscountActive,
    this.isLastMinuteDiscountActive,
    this.minimumPricePerPerson,
    this.remainingSpots,
  );

  String get formattedStartDate =>
      DateFormat('dd.MM.yyyy').format(tripStartDate!);

  String get formattedEndDate => DateFormat('dd.MM.yyyy').format(tripEndDate!);

  String get formattedStartDateTime => DateFormat('dd.MM.yyyy HH:mm').format(tripStartDate!);

  String get formatedEndDateTime => DateFormat('dd.MM.yyyy HH:mm').format(tripEndDate!);

  String get formatedFirstPaymentDeadline => DateFormat('dd.MM.yyyy').format(firstPaymentDeadline!);

  String get formatedLastPaymentDeadline => DateFormat('dd.MM.yyyy').format(lastPaymentDeadline!);

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      json["id"],
      json["tripStartDate"] !=null ? DateTime.parse(json["tripStartDate"]) : null,
      json["tripEndDate"] != null ? DateTime.parse(json["tripEndDate"]) : null,
      json["numberOfNights"],
      json["carriers"],
      json["description"],
      json["firstPaymentDeadline"]!=null ? DateTime.parse(json["firstPaymentDeadline"]) : null,
      json["lastPaymentDeadline"] !=null ? DateTime.parse(json["lastPaymentDeadline"]) : null,
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
      json["isFirstMinuteDiscountActive"],
      json["isLastMinuteDiscountActive"],
      json["minimumPricePerPerson"] != null ? (json["minimumPricePerPerson"] as num).toDouble() : null,
      json["remainingSpots"],
    );
  }
}
