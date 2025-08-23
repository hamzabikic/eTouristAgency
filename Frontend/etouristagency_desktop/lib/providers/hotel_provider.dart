import 'package:etouristagency_desktop/models/hotel/hotel.dart';
import 'package:etouristagency_desktop/models/hotel/hotel_image_info.dart';
import 'package:etouristagency_desktop/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class HotelProvider extends BaseProvider<Hotel> {
  HotelProvider() : super("Hotel");

  @override
  Hotel jsonToModel(json) {
    return Hotel.fromJson(json);
  }

  Future<HotelImageInfo> getHotelImage(String hotelImageId) async {
    var url = Uri.parse("${controllerUrl}/${hotelImageId}/image");

    var response = await http.get(
      url,
      headers: {"Authorization": (await authService.getBasicKey())!},
    );

    if (response.statusCode != 200)
      throw Exception("Greška pri učitavanju dokumenta: ${response.body}");

    return HotelImageInfo(
      null,
      response.bodyBytes,
      response.headers["imagename"],
    );
  }
}
