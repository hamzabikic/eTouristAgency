import 'package:etouristagency_desktop/models/reservation_review/reservation_review.dart';
import 'package:etouristagency_desktop/providers/base_provider.dart';

class ReservationReviewProvider extends BaseProvider<ReservationReview> {
  ReservationReviewProvider(): super("ReservationReview");

  @override
  ReservationReview jsonToModel(json) {
    return ReservationReview.fromJson(json);
  }
}