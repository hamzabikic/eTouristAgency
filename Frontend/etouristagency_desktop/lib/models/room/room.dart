import 'package:etouristagency_desktop/models/room_type/room_type.dart';

class Room {
  String? id;
  String? roomTypeId;
  String? offerId;
  double? pricePerPerson;
  double? childDiscount;
  int? quantity;
  String? shortDescription;
  RoomType? roomType;

  Room({
    this.id,
    this.roomTypeId,
    this.offerId,
    this.pricePerPerson,
    this.childDiscount,
    this.quantity,
    this.shortDescription,
    this.roomType,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json["id"],
      roomTypeId: json["roomTypeId"],
      offerId: json["offerId"],
      pricePerPerson: json["pricePerPerson"],
      childDiscount: json["childDiscount"],
      quantity: json["quantity"],
      shortDescription: json["shortDescription"],
      roomType: json["roomType"] != null ? RoomType.fromJson(json["roomType"]) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "roomTypeId": roomTypeId,
      "offerId": offerId,
      "pricePerPerson": pricePerPerson?.toString(),
      "childDiscount": childDiscount?.toString(),
      "quantity": quantity?.toString(),
      "shortDescription": shortDescription,
    };
  }
}
