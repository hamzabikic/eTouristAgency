import 'package:etouristagency_desktop/models/hotel/hotel.dart';
import 'package:etouristagency_desktop/providers/base_provider.dart';

class HotelProvider extends BaseProvider<Hotel> {
  HotelProvider():super("Hotel");

  @override
  Hotel jsonToModel(json) {
    return Hotel.fromJson(json);
  }
}