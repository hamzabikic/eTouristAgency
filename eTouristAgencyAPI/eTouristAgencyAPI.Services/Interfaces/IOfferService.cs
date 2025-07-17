using eTouristAgencyAPI.Models.RequestModels.Offer;
using eTouristAgencyAPI.Models.ResponseModels.Offer;
using eTouristAgencyAPI.Models.SearchModels;
using eTouristAgencyAPI.Services.Database.Models;

namespace eTouristAgencyAPI.Services.Interfaces
{
    public interface IOfferService : ICRUDService<Offer, OfferResponse, OfferSearchModel, AddOfferRequest, UpdateOfferRequest>
    {
    }
}
