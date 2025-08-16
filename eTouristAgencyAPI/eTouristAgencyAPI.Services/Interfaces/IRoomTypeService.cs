using eTouristAgencyAPI.Models.RequestModels.RoomType;
using eTouristAgencyAPI.Models.ResponseModels.RoomType;
using eTouristAgencyAPI.Models.SearchModels;
using eTouristAgencyAPI.Services.Database.Models;

namespace eTouristAgencyAPI.Services.Interfaces
{
    public interface IRoomTypeService : ICRUDService<RoomType, RoomTypeResponse, RoomTypeSearchModel, AddRoomTypeRequest, UpdateRoomTypeRequest>
    {
    }
}
