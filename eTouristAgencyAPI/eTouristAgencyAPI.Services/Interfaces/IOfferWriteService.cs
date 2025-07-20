using eTouristAgencyAPI.Models.RequestModels.Offer;
using eTouristAgencyAPI.Models.ResponseModels.Offer;

namespace eTouristAgencyAPI.Services.Interfaces
{
    public interface IOfferWriteService
    {
        Task<OfferResponse> AddAsync(AddOfferRequest insertModel);
        Task<OfferResponse> UpdateAsync(Guid id, UpdateOfferRequest updateModel);
    }
}
