class HotelImage {
  String? id;

  HotelImage(this.id);

  factory HotelImage.fromJson(Map<String, dynamic> json) {
    return HotelImage(json["id"]);
  }
}