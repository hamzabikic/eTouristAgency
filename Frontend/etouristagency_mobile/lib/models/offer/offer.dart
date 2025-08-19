import 'package:etouristagency_mobile/consts/app_constants.dart';
import 'package:etouristagency_mobile/helpers/format_helper.dart';
import 'package:etouristagency_mobile/models/entity_code_value/entity_code_value.dart';
import 'package:etouristagency_mobile/models/hotel/hotel.dart';
import 'package:etouristagency_mobile/models/offer/offer_document.dart';
import 'package:etouristagency_mobile/models/offer/offer_image.dart';
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
  OfferDocument? offerDocument;
  OfferImage? offerImage;

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
    this.offerDocument,
    this.offerImage,
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
      json["offerDocument"] != null
          ? OfferDocument.fromJson(json["offerDocument"])
          : null,
      json["offerImage"] != null
          ? OfferImage.fromJson(json["offerImage"])
          : null,
      json["isFirstMinuteDiscountActive"],
      json["isLastMinuteDiscountActive"],
      json["minimumPricePerPerson"] != null ? (json["minimumPricePerPerson"] as num).toDouble() : null,
      json["remainingSpots"],
    );
  }
}
