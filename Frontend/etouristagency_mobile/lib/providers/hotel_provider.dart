import 'package:etouristagency_mobile/models/hotel/hotel.dart';
import 'package:etouristagency_mobile/providers/base_provider.dart';

class HotelProvider extends BaseProvider {
  HotelProvider() : super("Hotel");

  @override
  jsonToModel(Map<String, dynamic> json) {
    return Hotel.fromJson(json);
  }
}
