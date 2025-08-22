class ReservationPayment {
  String? id;
  String? documentBytes;
  String? documentName;

  ReservationPayment(this.id, this.documentBytes, this.documentName);

  factory ReservationPayment.fromJson(Map<String, dynamic> json) {
    return ReservationPayment(
      json["id"],
      json["documentBytes"],
      json["documentName"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "documentBytes": documentBytes,
      "documentName": documentName,
    };
  }
}