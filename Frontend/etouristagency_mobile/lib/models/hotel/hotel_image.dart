class HotelImage {
  String? id;
  String? imageBytes;

  HotelImage(this.id, this.imageBytes);

  factory HotelImage.fromJson(Map<String, dynamic> json) {
    return HotelImage(json["id"], json["imageBytes"]);
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "imageBytes": imageBytes};
  }
}