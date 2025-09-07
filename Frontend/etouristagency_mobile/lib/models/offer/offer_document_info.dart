import 'dart:typed_data';

class OfferDocumentInfo {
  Uint8List? documentBytes;
  String? documentName;

  OfferDocumentInfo(this.documentBytes, this.documentName);
}