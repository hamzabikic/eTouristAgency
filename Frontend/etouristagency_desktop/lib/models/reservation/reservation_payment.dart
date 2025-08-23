class ReservationPayment {
  String? id;

  ReservationPayment(this.id);

  factory ReservationPayment.fromJson(Map<String, dynamic> json) {
    return ReservationPayment(json["id"]);
  }

  Map<String, dynamic> toJson() {
    return {"id": id};
  }
}
