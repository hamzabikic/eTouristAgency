import 'package:etouristagency_desktop/models/room/room.dart';

class RoomAccordionItem {
  String? id;
  String? roomTypeId;
  String? offerId;
  String? pricePerPerson;
  String? childDiscount;
  String? quantity;
  String? shortDescription;
  int? remainingQuantity;

  RoomAccordionItem({
    this.id,
    this.roomTypeId = "",
    this.offerId,
    this.pricePerPerson,
    this.childDiscount,
    this.quantity,
    this.shortDescription,
    this.remainingQuantity
  });

  factory RoomAccordionItem.fromRoom(Room room) {
    return RoomAccordionItem(
      id: room.id,
      roomTypeId: room.roomTypeId,
      offerId: room.offerId,
      pricePerPerson: room.pricePerPerson?.toString(),
      childDiscount: room.childDiscount?.toString(),
      quantity: room.quantity?.toString(),
      shortDescription: room.shortDescription,
      remainingQuantity: room.remainingQuantity
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "roomTypeId": roomTypeId,
      "offerId": offerId,
      "pricePerPerson": pricePerPerson,
      "childDiscount": childDiscount,
      "quantity": quantity,
      "shortDescription": shortDescription,
    };
  }
}
