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

        public ActiveOfferStatusService(IServiceProvider serviceProvider,
                                        eTouristAgencyDbContext dbContext,
                                        IMapper mapper,
                                        IOfferWriteService offerWriteService) : base(serviceProvider, dbContext, mapper)
        {
            _offerWriteService = offerWriteService;
        }

        public override Task<OfferResponse> UpdateAsync(Guid id, UpdateOfferRequest updateModel)
        {
            return _offerWriteService.UpdateAsync(id, updateModel);
        }

        public override async Task DeactivateAsync(Guid offerId)
        {
            var offer = await _dbContext.Offers.FindAsync(offerId);

            if (offer == null) throw new Exception("Offer with provided id is not found.");

            offer.OfferStatusId = AppConstants.FixedOfferStatusInactive;

            await _dbContext.SaveChangesAsync();
        }
    }
}
