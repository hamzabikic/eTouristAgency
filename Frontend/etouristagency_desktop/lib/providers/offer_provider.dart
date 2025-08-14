import 'package:etouristagency_desktop/models/offer/offer.dart';
import 'package:etouristagency_desktop/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class OfferProvider extends BaseProvider<Offer> {
  OfferProvider() : super("Offer");

  @override
  jsonToModel(json) {
    return Offer.fromJson(json);
  }

  Future activate(String offerId) async {
    var url = Uri.parse("${controllerUrl}/${offerId}/activate");

    var response = await http.patch(
      url,
      headers: {
        "Authorization": (await authService.getBasicKey())!,
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        "Dogodila se greška prilikom aktiviranja ponude ${response.body}",
      );
    }
  }

  Future deactivate(String offerId) async{
    var url = Uri.parse("${controllerUrl}/${offerId}/deactivate");

    var response = await http.patch(
      url,
      headers: {
        "Authorization": (await authService.getBasicKey())!,
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        "Dogodila se greška prilikom aktiviranja ponude ${response.body}",
      );
    }
  }
}
