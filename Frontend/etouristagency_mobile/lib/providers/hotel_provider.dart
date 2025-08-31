import 'package:etouristagency_mobile/helpers/auth_navigation_helper.dart';
import 'package:etouristagency_mobile/models/hotel/hotel.dart';
import 'package:etouristagency_mobile/models/hotel/hotel_image_info.dart';
import 'package:etouristagency_mobile/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class HotelProvider extends BaseProvider {
  HotelProvider() : super("Hotel");

  @override
  jsonToModel(Map<String, dynamic> json) {
    return Hotel.fromJson(json);
  }

  Future<HotelImageInfo> getHotelImage(String hotelImageId) async {
    var url = Uri.parse("${controllerUrl}/${hotelImageId}/image");

    var response = await http.get(
      url,
      headers: {"Authorization": (await authService.getBasicKey())!},
    );

    if (response.statusCode == 401) {
      await AuthNavigationHelper.handleUnauthorized();

      return HotelImageInfo(null, null);
    }

    return HotelImageInfo(response.bodyBytes, response.headers["imagename"]);
  }
}
