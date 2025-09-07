using eTouristAgencyAPI.Models.RequestModels.Room;
using eTouristAgencyAPI.Models.ResponseModels.Room;

namespace eTouristAgencyAPI.Services.Interfaces
{
    public interface IRoomService
    {
        Task<List<RoomResponse>> AddByOfferIdAsync(Guid offerId, List<AddRoomRequest> roomList);

        Task<List<RoomResponse>> UpdateAsync(Guid offerId, List<UpdateRoomRequest> roomList);
    }
}
