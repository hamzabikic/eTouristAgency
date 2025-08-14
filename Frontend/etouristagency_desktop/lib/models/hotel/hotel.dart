import 'package:etouristagency_desktop/models/city/city.dart';
import 'package:etouristagency_desktop/models/hotel/hotel_image.dart';

class Hotel {
  String? id;
  String? name;
  int? starRating;
  String? cityId;
  City? city;
  List<HotelImage>? hotelImages;

  Hotel(this.id, this.name, this.starRating, this.cityId, this.city, this.hotelImages);

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      json["id"],
      json["name"],
      json["starRating"],
      json["cityId"],
      json["city"] != null ? City.fromJson(json["city"]) : null,
      json["hotelImages"] != null ? (json["hotelImages"] as List).map((x)=> HotelImage.fromJson(x)).toList() : null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "starRating": starRating?.toString(),
      "cityId": cityId,
      "city": city?.toJson(),
      "hotelImages" : hotelImages?.map((x)=> x.toJson()).toList()
    };
  }
}
