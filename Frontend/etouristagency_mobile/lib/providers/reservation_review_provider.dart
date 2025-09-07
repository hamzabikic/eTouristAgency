import 'package:etouristagency_mobile/models/reservation_review/reservation_review.dart';
import 'package:etouristagency_mobile/providers/base_provider.dart';

class ReservationReviewProvider extends BaseProvider<ReservationReview>
{
  ReservationReviewProvider() :super("ReservationReview");

  @override
  ReservationReview jsonToModel(Map<String, dynamic> json) {
    return ReservationReview.fromJson(json);
  }
}