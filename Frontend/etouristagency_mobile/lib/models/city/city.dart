import 'package:etouristagency_mobile/models/country/country.dart';

class City {
  String? id;
  String? name;
  String? countryId;
  Country? country;

  City(this.id, this.name, this.countryId, this.country);

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      json["id"],
      json["name"],
      json["countryId"],
      json["country"] != null ? Country.fromJson(json["country"]) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "countryId": countryId,
      "country": country?.toJson(),
    };
  }
}