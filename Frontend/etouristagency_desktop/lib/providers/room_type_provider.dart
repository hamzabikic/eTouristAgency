import 'package:etouristagency_desktop/models/room_type/room_type.dart';
import 'package:etouristagency_desktop/providers/base_provider.dart';

class RoomTypeProvider extends BaseProvider<RoomType>{
  RoomTypeProvider():super("RoomType");

  @override
  RoomType jsonToModel(json) {
    return RoomType.fromJson(json);
  }
}