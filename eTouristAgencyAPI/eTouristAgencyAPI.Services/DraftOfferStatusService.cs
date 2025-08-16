using eTouristAgencyAPI.Models.RequestModels.Offer;
using eTouristAgencyAPI.Models.ResponseModels.Offer;
using eTouristAgencyAPI.Services.Constants;
using eTouristAgencyAPI.Services.Database;
using eTouristAgencyAPI.Services.Interfaces;
using MapsterMapper;

namespace eTouristAgencyAPI.Services
{
    public class DraftOfferStatusService : BaseOfferStatusService
    {
        private readonly IOfferWriteService _offerWriteService;
        private readonly IRoomService _roomService;
        private readonly IOfferDiscountService _offerDiscountService;

        public DraftOfferStatusService(IServiceProvider serviceProvider,
                                       eTouristAgencyDbContext dbContext,
                                       IMapper mapper,
                                       IOfferWriteService offerWriteService,
                                       IRoomService roomService,
                                       IOfferDiscountService offerDiscountService) : base(serviceProvider, dbContext, mapper)
        {
            _offerWriteService = offerWriteService;
            _roomService = roomService;
            _offerDiscountService = offerDiscountService;
        }

        public override async Task<OfferResponse> UpdateAsync(Guid id, UpdateOfferRequest updateModel)
        {
            var offerResponse = await _offerWriteService.UpdateAsync(id, updateModel);

            offerResponse.Rooms = await _roomService.UpdateAsync(id, updateModel.RoomList);

            if (updateModel.DiscountList != null)
            {
                offerResponse.OfferDiscounts = await _offerDiscountService.UpdateAsync(id, updateModel.DiscountList);
            }

            return offerResponse;
        }

        public override async Task ActivateAsync(Guid offerId)
        {
            var offer = await _dbContext.Offers.FindAsync(offerId);

            if (offer == null) throw new Exception("Offer with provided id is not found.");

            offer.OfferStatusId = AppConstants.FixedOfferStatusActive;

            await _dbContext.SaveChangesAsync();
        }
    }
}
