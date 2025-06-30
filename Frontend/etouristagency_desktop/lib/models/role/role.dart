class Role {
  String? id;
  String? name;

  Role(this.id, this.name);

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(json["id"], json["name"]);
  }
}