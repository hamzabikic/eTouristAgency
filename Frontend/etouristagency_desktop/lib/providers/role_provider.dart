import 'package:etouristagency_desktop/models/paginated_list.dart';
import 'package:etouristagency_desktop/models/role/role.dart';
import 'package:etouristagency_desktop/providers/base_provider.dart';

class RoleProvider extends BaseProvider<Role> {
  RoleProvider() : super("Role");

  @override
  PaginatedList<Role> fromJson(json) {
    var roleList = (json["listOfRecords"] as List).map((x)=> Role.fromJson(x)).toList();
    
    return PaginatedList(roleList, json["totalPages"]);
  }
}