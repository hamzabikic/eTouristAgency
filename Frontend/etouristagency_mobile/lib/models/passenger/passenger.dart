class Passenger {
  String? id;
  String? fullName;
  String? phoneNumber;
  DateTime? dateOfBirth;

  Passenger(this.id, this.fullName, this.phoneNumber, this.dateOfBirth);

  factory Passenger.fromJson(Map<String, dynamic> json) {
    return Passenger(
      json["id"],
      json["fullName"],
      json["phoneNumber"],
      json["dateOfBirth"] != null ? DateTime.parse(json["dateOfBirth"]) : null,
    );
  }

  Map<String, dynamic> toJson(Passenger passenger){
    return {
      "id" : passenger.id,
      "fullName" : passenger.fullName,
      "phoneNumber" : passenger.phoneNumber,
      "dateOfBirth" : passenger.dateOfBirth
    };
  }
}
