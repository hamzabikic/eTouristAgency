import 'package:etouristagency_mobile/models/offer/offer.dart';
import 'package:etouristagency_mobile/models/offer/offer_document_info.dart';
import 'package:etouristagency_mobile/models/offer/offer_image_info.dart';
import 'package:etouristagency_mobile/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class OfferProvider extends BaseProvider<Offer> {
  OfferProvider() : super("Offer");

  @override
  Offer jsonToModel(Map<String, dynamic> json) {
    return Offer.fromJson(json);
  }

  Future<OfferImageInfo> getOfferImage(String id) async {
    var url = Uri.parse("${controllerUrl}/${id}/image");

    var response = await http.get(
      url,
      headers: {"Authorization": (await authService.getBasicKey())!},
    );

    if (response.statusCode != 200) {
      throw Exception(
        "Dogodila se greška prilikom dohvatanja slike :${response.body}",
      );
    }

    return OfferImageInfo(response.bodyBytes, response.headers["imagename"]);
  }

  Future<OfferDocumentInfo> getOfferDocument(String id) async {
    var url = Uri.parse("${controllerUrl}/${id}/document");

    var response = await http.get(
      url,
      headers: {"Authorization": (await authService.getBasicKey())!},
    );

    if (response.statusCode != 200) {
      throw Exception(
        "Dogodila se greška prilikom dohvatanja dokumenta :${response.body}",
      );
    }

    return OfferDocumentInfo(
      response.bodyBytes,
      response.headers["documentname"],
    );
  }
}
