import 'package:etouristagency_desktop/models/offer_discount/offer_discount.dart';

class DiscountAccordionItem {
  String? id;
  String? discountTypeId;
  String? discount;
  DateTime? validFrom;
  DateTime? validTo;
  bool? isEditable;
  bool? isRemovable;

  DiscountAccordionItem({
    this.id,
    this.discountTypeId,
    this.discount,
    this.validFrom,
    this.validTo,
    this.isEditable,
    this.isRemovable
  });

  factory DiscountAccordionItem.fromOfferDiscount(OfferDiscount discount) {
    return DiscountAccordionItem(
      id: discount.id,
      discountTypeId: discount.discountTypeId,
      discount: discount.discount?.toString(),
      validFrom: discount.validFrom,
      validTo: discount.validTo,
      isEditable: discount.isEditable,
      isRemovable: discount.isRemovable
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "discountTypeId": discountTypeId,
      "discount": discount,
      "validFrom": validFrom,
      "validTo": validTo,
    };
  }
}
