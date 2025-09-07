import 'dart:convert';
import 'dart:typed_data';

class PassengerDocument {
  String? documentName;
  Uint8List? documentBytes;

  PassengerDocument(this.documentName, this.documentBytes);

  Map<String, dynamic> toJson(){
    return {
      "documentName" : documentName,
      "documentBytes" : base64Encode(documentBytes!)
    };
  }
}