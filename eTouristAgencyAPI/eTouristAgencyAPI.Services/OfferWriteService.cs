using eTouristAgencyAPI.Models.RequestModels.Offer;
using eTouristAgencyAPI.Models.ResponseModels;
using eTouristAgencyAPI.Models.ResponseModels.Offer;
using eTouristAgencyAPI.Models.SearchModels;
using eTouristAgencyAPI.Services.Constants;
using eTouristAgencyAPI.Services.Database;
using eTouristAgencyAPI.Services.Database.Models;
using eTouristAgencyAPI.Services.Interfaces;
using MapsterMapper;

namespace eTouristAgencyAPI.Services
{
    public class OfferWriteService : CRUDService<Offer, OfferResponse, OfferSearchModel, AddOfferRequest, UpdateOfferRequest>, IOfferWriteService
    {
        private readonly IRoomService _roomService;
        private readonly IOfferDiscountService _offerDiscountService;
        private readonly Guid? _userId;

        public OfferWriteService(eTouristAgencyDbContext dbContext,
                                IMapper mapper,
                                IUserContextService userContextService,
                                IRoomService roomService,
                                IOfferDiscountService offerDiscountService) : base(dbContext, mapper)
        {
            _roomService = roomService;
            _offerDiscountService = offerDiscountService;
            _userId = userContextService.GetUserId();
        }

        protected override async Task BeforeInsertAsync(AddOfferRequest insertModel, Offer dbModel)
        {
            dbModel.Id = Guid.NewGuid();
            dbModel.CreatedBy = _userId ?? Guid.Empty;
            dbModel.ModifiedBy = _userId ?? Guid.Empty;
            dbModel.OfferStatusId = AppConstants.FixedOfferStatusDraft;
        }

        public override Task<PaginatedList<OfferResponse>> GetAllAsync(OfferSearchModel searchModel)
        {
            throw new NotImplementedException();
        }

        public override Task<OfferResponse> GetByIdAsync(Guid id)
        {
            throw new NotImplementedException();
        }

        protected override async Task BeforeUpdateAsync(UpdateOfferRequest updateModel, Offer dbModel)
        {
            dbModel.ModifiedOn = DateTime.Now;
            dbModel.ModifiedBy = _userId ?? Guid.Empty;
        }
    }
}
