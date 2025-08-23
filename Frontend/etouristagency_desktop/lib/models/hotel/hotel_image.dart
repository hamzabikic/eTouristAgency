class HotelImage {
  String? id;

  HotelImage(this.id);

  factory HotelImage.fromJson(Map<String, dynamic> json) {
    return HotelImage(json["id"]);
  }

  Map<String, dynamic> toJson() {
    return {"id": id};
  }
}
