using eTouristAgencyAPI.Models.RequestModels.Offer;
using eTouristAgencyAPI.Models.ResponseModels.Offer;
using eTouristAgencyAPI.Services.Database;
using eTouristAgencyAPI.Services.Interfaces;
using MapsterMapper;

namespace eTouristAgencyAPI.Services
{
    public class InitialOfferStatusService : BaseOfferStatusService
    {
        private readonly IOfferWriteService _offerWriteService;
        private readonly IRoomService _roomService;
        private readonly IOfferDiscountService _offerDiscountService;

        public InitialOfferStatusService(IServiceProvider serviceProvider,
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

        public override async Task<OfferResponse> AddAsync(AddOfferRequest insertModel)
        {
            var offerResponse = await _offerWriteService.AddAsync(insertModel);

            offerResponse.Rooms = await _roomService.AddByOfferIdAsync(offerResponse.Id, insertModel.RoomList);

            if (insertModel.DiscountList != null && insertModel.DiscountList.Any())
            {
                offerResponse.OfferDiscounts = await _offerDiscountService.AddByOfferIdAsync(offerResponse.Id, insertModel.DiscountList);
            }

            return offerResponse;
        }
    }
}
