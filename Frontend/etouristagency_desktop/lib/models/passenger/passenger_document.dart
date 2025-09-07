import 'dart:typed_data';

class PassengerDocument {
  String? documentName;
  Uint8List? documentBytes;

  PassengerDocument(this.documentName, this.documentBytes);
}