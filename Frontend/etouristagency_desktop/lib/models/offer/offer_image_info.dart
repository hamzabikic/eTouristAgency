import 'package:flutter/services.dart';

class OfferImageInfo{
  Uint8List? imageBytes;
  String? imageName;

  OfferImageInfo(this.imageBytes, this.imageName);
}