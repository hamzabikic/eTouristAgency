import 'dart:convert';

import 'package:flutter/services.dart';

class HotelImageInfo {
  String? id;
  Uint8List? imageBytes;
  String? imageName;

  HotelImageInfo(this.id, this.imageBytes, this.imageName);

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "imageBytes": base64Encode(imageBytes!),
      "imageName": imageName,
    };
  }
}