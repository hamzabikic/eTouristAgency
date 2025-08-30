import 'package:etouristagency_mobile/models/country/country.dart';
import 'package:etouristagency_mobile/providers/base_provider.dart';

class CountryProvider extends BaseProvider<Country> {
  CountryProvider() : super("Country");

  @override
  Country jsonToModel(Map<String, dynamic> json) {
    return Country.fromJson(json);
  }
}