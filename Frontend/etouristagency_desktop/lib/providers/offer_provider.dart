import 'package:etouristagency_desktop/helpers/auth_navigation_helper.dart';
import 'package:etouristagency_desktop/models/offer/offer.dart';
import 'package:etouristagency_desktop/models/offer/offer_document_info.dart';
import 'package:etouristagency_desktop/models/offer/offer_image_info.dart';
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

    if (response.statusCode == 401) {
      await AuthNavigationHelper.handleUnauthorized();
      return;
    }

    if (response.statusCode != 200) {
      throw Exception(
        "Dogodila se greška prilikom aktiviranja ponude ${response.body}",
      );
    }
  }

  Future deactivate(String offerId) async {
    var url = Uri.parse("${controllerUrl}/${offerId}/deactivate");

    var response = await http.patch(
      url,
      headers: {
        "Authorization": (await authService.getBasicKey())!,
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 401) {
      await AuthNavigationHelper.handleUnauthorized();
      return;
    }

    if (response.statusCode != 200) {
      throw Exception(
        "Dogodila se greška prilikom aktiviranja ponude ${response.body}",
      );
    }
  }

  Future<OfferImageInfo> getOfferImage(String id) async {
    var url = Uri.parse("${controllerUrl}/${id}/image");

    var response = await http.get(
      url,
      headers: {"Authorization": (await authService.getBasicKey())!},
    );

    if (response.statusCode == 401) {
      await AuthNavigationHelper.handleUnauthorized();
      return OfferImageInfo(null, null);
    }

    if (response.statusCode != 200)
      throw Exception("Greška pri učitavanju slike: ${response.body}");

    return OfferImageInfo(response.bodyBytes, response.headers["imagename"]);
  }

  Future<OfferDocumentInfo> getOfferDocument(String id) async {
    var url = Uri.parse("${controllerUrl}/${id}/document");

    var response = await http.get(
      url,
      headers: {"Authorization": (await authService.getBasicKey())!},
    );

    if (response.statusCode == 401) {
      await AuthNavigationHelper.handleUnauthorized();
      return OfferDocumentInfo(null, null);
    }

    if (response.statusCode != 200)
      throw Exception("Greška pri učitavanju dokumenta: ${response.body}");

    return OfferDocumentInfo(
      response.bodyBytes,
      response.headers["documentname"],
    );
  }
}
