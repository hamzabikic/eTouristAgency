class OfferImage {
  String? imageBytes;
  String? imageName;

  OfferImage(this.imageBytes, this.imageName);

  factory OfferImage.fromJson(Map<String, dynamic> json) {
    return OfferImage(json["imageBytes"], json["imageName"]);
  }
}
