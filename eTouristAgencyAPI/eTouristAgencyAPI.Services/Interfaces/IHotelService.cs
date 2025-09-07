using eTouristAgencyAPI.Models.RequestModels.Hotel;
using eTouristAgencyAPI.Models.ResponseModels.Hotel;
using eTouristAgencyAPI.Models.SearchModels;
using eTouristAgencyAPI.Services.Database.Models;

namespace eTouristAgencyAPI.Services.Interfaces
{
    public interface IHotelService : ICRUDService<Hotel, HotelResponse, HotelSearchModel, AddHotelRequest, UpdateHotelRequest>
    {
        Task<HotelImage> GetImageByHotelImageIdAsync(Guid hotelImageId);
    }
}
