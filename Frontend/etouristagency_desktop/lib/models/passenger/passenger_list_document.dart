import 'dart:typed_data';

class PassengerListDocument {
  Uint8List? documentBytes;
  String? documentName;

  PassengerListDocument(this.documentBytes, this.documentName);
}