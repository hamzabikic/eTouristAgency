import 'package:etouristagency_desktop/models/entity_code_value/entity_code_value.dart';

class OfferDiscount {
  String? id;
  String? discountTypeId;
  double? discount;
  DateTime? validFrom;
  DateTime? validTo;
  EntityCodeValue? discountType;
  bool? isEditable;
  bool? isRemovable;

  OfferDiscount({
    this.id,
    this.discountTypeId,
    this.discount,
    this.validFrom,
    this.validTo,
    this.discountType,
    this.isEditable,
    this.isRemovable,
  });

  factory OfferDiscount.fromJson(Map<String, dynamic> json) {
    return OfferDiscount(
      id: json["id"],
      discountTypeId: json["discountTypeId"],
      discount: json["discount"],
      validFrom: json["validFrom"] != null
          ? DateTime.parse(json["validFrom"])
          : null,
      validTo: json["validTo"] != null ? DateTime.parse(json["validTo"]) : null,
      discountType: json["discountType"] != null
          ? EntityCodeValue.fromJson(json["discountType"])
          : null,
      isEditable: json["isEditable"],
      isRemovable: json["isRemovable"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "discountTypeId": discountTypeId,
      "discount": discount?.toString(),
      "validFrom": validFrom,
      "validTo": validTo,
    };
  }
}
