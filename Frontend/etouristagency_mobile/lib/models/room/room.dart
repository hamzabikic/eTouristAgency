import 'package:etouristagency_mobile/models/room_type/room_type.dart';

class Room {
  String? id;
  String? roomTypeId;
  String? offerId;
  double? pricePerPerson;
  double? childDiscount;
  double? discountedPrice;
  int? quantity;
  String? shortDescription;
  RoomType? roomType;
  bool? isAvalible;

  Room({
    this.id,
    this.roomTypeId,
    this.offerId,
    this.pricePerPerson,
    this.childDiscount,
    this.quantity,
    this.shortDescription,
    this.roomType,
    this.isAvalible,
    this.discountedPrice
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json["id"],
      roomTypeId: json["roomTypeId"],
      offerId: json["offerId"],
      pricePerPerson: json["pricePerPerson"] != null
          ? (json["pricePerPerson"] as num).toDouble()
          : null,
      childDiscount: json["childDiscount"] != null
          ? (json["childDiscount"] as num).toDouble()
          : null,
      quantity: json["quantity"],
      shortDescription: json["shortDescription"],
      roomType: json["roomType"] != null
          ? RoomType.fromJson(json["roomType"])
          : null,
      isAvalible: json["isAvalible"],
      discountedPrice:  json["discountedPrice"] != null ? (json["discountedPrice"] as num).toDouble() : null
    );
  }
}
