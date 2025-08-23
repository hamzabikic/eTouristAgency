import 'dart:convert';
import 'dart:typed_data';

class ReservationPaymentInfo {
  Uint8List? documentBytes;
  String? documentName;

  ReservationPaymentInfo(this.documentBytes, this.documentName);

  Map<String, dynamic> toJson() {
    return {"documentBytes": base64Encode(documentBytes!), "documentName": documentName};
  }
}
