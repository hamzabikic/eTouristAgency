using eTouristAgencyAPI.Models.RequestModels.Offer;
using eTouristAgencyAPI.Models.ResponseModels.Offer;
using eTouristAgencyAPI.Services.Constants;
using eTouristAgencyAPI.Services.Database;
using eTouristAgencyAPI.Services.Interfaces;
using MapsterMapper;

namespace eTouristAgencyAPI.Services
{
    public class ActiveOfferStatusService : BaseOfferStatusService
    {
        private readonly IOfferWriteService _offerWriteService;
        private readonly IOfferDiscountService _offerDiscountService;

        public ActiveOfferStatusService(IServiceProvider serviceProvider,
                                        eTouristAgencyDbContext dbContext,
                                        IMapper mapper,
                                        IOfferWriteService offerWriteService,
                                        IOfferDiscountService offerDiscountService) : base(serviceProvider, dbContext, mapper)
        {
            _offerWriteService = offerWriteService;
            _offerDiscountService = offerDiscountService;
        }

        public override async Task<OfferResponse> UpdateAsync(Guid id, UpdateOfferRequest updateModel)
        {
            var offerResponse = await _offerWriteService.UpdateAsync(id, updateModel);

            if (updateModel.DiscountList != null) {
                offerResponse.OfferDiscounts = await _offerDiscountService.UpdateAsync(id, updateModel.DiscountList);
            }

            return offerResponse;
        }

        public override async Task DeactivateAsync(Guid offerId)
        {
            var offer = await _dbContext.Offers.FindAsync(offerId);

            if (offer == null) throw new Exception("Offer with provided id is not found.");

            if (offer.TripStartDate.Date <= DateTime.Now.Date) throw new Exception("Currently, you cannot update offer status.");

            offer.OfferStatusId = AppConstants.FixedOfferStatusInactive;

            await _dbContext.SaveChangesAsync();
        }
    }
}
