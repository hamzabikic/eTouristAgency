class Country {
  String? id;
  String? name;

  Country(this.id, this.name);

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(json["id"], json["name"]);
  }
}