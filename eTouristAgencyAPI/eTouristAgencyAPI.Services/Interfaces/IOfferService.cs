using eTouristAgencyAPI.Models.RequestModels.Offer;
using eTouristAgencyAPI.Models.ResponseModels.Offer;
using eTouristAgencyAPI.Models.SearchModels;
using eTouristAgencyAPI.Services.Database.Models;

namespace eTouristAgencyAPI.Services.Interfaces
{
    public interface IOfferService : ICRUDService<Offer, OfferResponse, OfferSearchModel, AddOfferRequest, UpdateOfferRequest>
    {
        Task ActivateAsync(Guid id);
        Task DeactivateAsync(Guid id);
        Task<OfferDocument> GetDocumentByIdAsync(Guid id);
        Task<OfferImage> GetImageByIdAsync(Guid id);
    }
}
