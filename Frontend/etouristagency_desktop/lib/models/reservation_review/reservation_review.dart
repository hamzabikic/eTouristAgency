import 'package:intl/intl.dart';

class ReservationReview {
  String? id;
  int? accommodationRating;
  int? serviceRating;
  String? description;
  DateTime? createdOn;
  ReservationReviewReservationResponse? reservation;

  String get formatedCreatedOn =>
      DateFormat("dd.MM.yyyy HH:mm").format(createdOn!);

  ReservationReview(
    this.id,
    this.accommodationRating,
    this.serviceRating,
    this.description,
    this.reservation,
    this.createdOn,
  );

  factory ReservationReview.fromJson(Map<String, dynamic> json) {
    return ReservationReview(
      json["id"],
      json["accommodationRating"],
      json["serviceRating"],
      json["description"],
      json["reservation"] != null
          ? ReservationReviewReservationResponse.fromJson(json["reservation"])
          : null,
      json["createdOn"] != null ? DateTime.parse(json["createdOn"]) : null,
    );
  }
}

class ReservationReviewReservationResponse {
  int? reservationNo;
  String? userId;
  ReservationReviewUserResponse? user;

  ReservationReviewReservationResponse(
    this.reservationNo,
    this.userId,
    this.user,
  );

  factory ReservationReviewReservationResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return ReservationReviewReservationResponse(
      json["reservationNo"],
      json["userId"],
      json["user"] != null
          ? ReservationReviewUserResponse.fromJson(json["user"])
          : null,
    );
  }
}

class ReservationReviewUserResponse {
  String? id;
  String? firstName;
  String? lastName;

  ReservationReviewUserResponse(this.id, this.firstName, this.lastName);

  factory ReservationReviewUserResponse.fromJson(Map<String, dynamic> json) {
    return ReservationReviewUserResponse(
      json["id"],
      json["firstName"],
      json["lastName"],
    );
  }
}
