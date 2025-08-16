import 'package:etouristagency_mobile/models/offer/offer.dart';
import 'package:etouristagency_mobile/providers/base_provider.dart';

class OfferProvider extends BaseProvider<Offer> {
  OfferProvider() : super("Offer");

  @override
  Offer jsonToModel(Map<String, dynamic> json) {
    return Offer.fromJson(json);
  }
}
