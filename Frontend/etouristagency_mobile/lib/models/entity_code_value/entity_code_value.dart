class EntityCodeValue {
  String? id;
  String? name;

  EntityCodeValue(this.id, this.name);

  factory EntityCodeValue.fromJson(Map<String, dynamic> json) {
    return EntityCodeValue(json["id"], json["name"]);
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "name": name};
  }
}