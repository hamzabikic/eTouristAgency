import 'package:etouristagency_desktop/models/role/role.dart';

class User {
  String? id;
  String? username;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
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
    this.isActive,
    this.isVerified,
    this.roles,
  );

  factory User.fromJson(Map<String, dynamic> json) {
    var roles = json["roles"] != null
        ? (json["roles"] as List).map((x) => Role.fromJson(x)).toList()
        : null;
        
    return User(
      json["id"],
      json["username"],
      json["firstName"],
      json["lastName"],
      json["email"],
      json["phoneNumber"],
      json["isActive"],
      json["isVerified"],
      roles,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "username": username,
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "phoneNumber": phoneNumber,
      "isActive": isActive,
      "isVerified": isVerified,
      "roles": roles?.map((e) => e.toJson()).toList(),
    };
  }
}
