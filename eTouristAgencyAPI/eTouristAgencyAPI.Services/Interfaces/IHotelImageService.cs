using eTouristAgencyAPI.Models.RequestModels.Hotel;

namespace eTouristAgencyAPI.Services.Interfaces
{
    public interface IHotelImageService
    {
        Task UpdateAsync(Guid hotelId, List<UpdateHotelImageRequest> hotelImages);
    }
}
