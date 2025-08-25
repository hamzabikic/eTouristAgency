class ReservationReview {
  String? id;
  int? accommodationRating;
  int? serviceRating;
  String? description;
  ReservationReviewReservationResponse? reservation;

  ReservationReview(
    this.id,
    this.accommodationRating,
    this.serviceRating,
    this.description,
    this.reservation,
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
    );
  }
}

class ReservationReviewReservationResponse {
  String? userId;
  ReservationReviewUserResponse? user;

  ReservationReviewReservationResponse(this.userId, this.user);

  factory ReservationReviewReservationResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return ReservationReviewReservationResponse(
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
