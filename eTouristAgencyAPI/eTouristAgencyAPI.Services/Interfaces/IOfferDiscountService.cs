using eTouristAgencyAPI.Models.RequestModels.OfferDiscount;
using eTouristAgencyAPI.Models.ResponseModels.OfferDiscount;
using eTouristAgencyAPI.Models.SearchModels;
using eTouristAgencyAPI.Services.Database.Models;

namespace eTouristAgencyAPI.Services.Interfaces
{
    public interface IOfferDiscountService
    {
        Task<List<OfferDiscountResponse>> AddByOfferIdAsync(Guid offerId, List<AddOfferDiscountRequest> offerDiscountList);
        Task<List<OfferDiscountResponse>> UpdateAsync(Guid offerId, List<UpdateOfferDiscountRequest> offerDiscountList);
    }
}