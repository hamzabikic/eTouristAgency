import 'package:etouristagency_desktop/models/city/city.dart';
import 'package:etouristagency_desktop/providers/base_provider.dart';

class CityProvider extends BaseProvider<City> {
  CityProvider() : super("City");

  @override
  City jsonToModel(json) {
    return City.fromJson(json);
  }
}
