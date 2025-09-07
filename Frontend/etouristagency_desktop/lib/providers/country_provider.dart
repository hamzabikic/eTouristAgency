import 'package:etouristagency_desktop/models/country/country.dart';
import 'package:etouristagency_desktop/providers/base_provider.dart';

class CountryProvider extends BaseProvider<Country> {
  CountryProvider() : super("Country");

  @override
  Country jsonToModel(json) {
    return Country.fromJson(json);
  }
}
