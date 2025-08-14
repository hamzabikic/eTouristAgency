class RoomType {
  String? id;
  String? name;
  int? roomCapacity;

  RoomType(this.id, this.name, this.roomCapacity);

  factory RoomType.fromJson(Map<String, dynamic> json) {
    return RoomType(json["id"], json["name"], json["roomCapacity"]);
  }
}