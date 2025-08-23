import 'package:etouristagency_mobile/models/entity_code_value/entity_code_value.dart';

class OfferDiscount {
  String? id;
  String? discountTypeId;
  double? discount;
  DateTime? validFrom;
  DateTime? validTo;
  EntityCodeValue? discountType;

  bool isUpdateEnabled() {
    return DateTime.now().isBefore(validFrom ?? DateTime.now());
  }

  OfferDiscount({
    this.id,
    this.discountTypeId,
    this.discount,
    this.validFrom,
    this.validTo,
    this.discountType,
  });

  factory OfferDiscount.fromJson(Map<String, dynamic> json) {
    return OfferDiscount(
      id: json["id"],
      discountTypeId: json["discountTypeId"],
      discount: json["discount"] != null
          ? (json["discount"] as num).toDouble()
          : null,
      validFrom: DateTime.parse(json["validFrom"]),
      validTo: DateTime.parse(json["validTo"]),
      discountType: json["discountType"] != null
          ? EntityCodeValue.fromJson(json["discountType"])
          : null,
    );
  }
}
