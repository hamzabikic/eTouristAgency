class OfferDocument {
  String? documentBytes;
  String? documentName;

  OfferDocument(this.documentBytes, this.documentName);

  factory OfferDocument.fromJson(Map<String, dynamic> json) {
    return OfferDocument(json["documentBytes"], json["documentName"]);
  }
}
