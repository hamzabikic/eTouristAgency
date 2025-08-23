import 'package:flutter/services.dart';

class OfferDocumentInfo {
  Uint8List? documentBytes;
  String? documentName;

  OfferDocumentInfo(this.documentBytes, this.documentName);
}