import 'package:etouristagency_desktop/models/role/role.dart';

class User {
  String? id;
  String? username;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  DateTime? createdOn;
  DateTime? modifiedOn;
  bool? isActive;
  bool? isVerified;
  List<Role>? roles;

  User(
    this.id,
    this.username,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.createdOn,
    this.modifiedOn,
    this.isActive,
    this.isVerified,
    this.roles,
  );

  factory User.fromJson(Map<String, dynamic> json) {
    var roles = (json["roles"] as List).map((x) => Role.fromJson(x)).toList();
    return User(
      json["id"],
      json["username"],
      json["firstName"],
      json["lastName"],
      json["email"],
      json["phoneNumber"],
      DateTime.parse(json["createdOn"]),
      DateTime.parse(json["modifiedOn"]),
      json["isActive"],
      json["isVerified"],
      roles,
    );
  }
}