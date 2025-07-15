import 'package:etouristagency_desktop/models/paginated_list.dart';
import 'package:etouristagency_desktop/models/role/role.dart';
import 'package:etouristagency_desktop/providers/base_provider.dart';

class RoleProvider extends BaseProvider<Role> {
  RoleProvider() : super("Role");

  @override
  Role jsonToModel(json) {
    return Role.fromJson(json);
  }
}