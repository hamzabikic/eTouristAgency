import 'package:flutter/services.dart';

class ReservationPaymentInfo {
  Uint8List? documentBytes;
  String? documentName;

  ReservationPaymentInfo(this.documentBytes, this.documentName);
}