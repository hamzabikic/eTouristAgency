using eTouristAgencyAPI.Models.RequestModels.Offer;
using eTouristAgencyAPI.Models.ResponseModels.Offer;
using eTouristAgencyAPI.Models.SearchModels;
using eTouristAgencyAPI.Services.Constants;
using eTouristAgencyAPI.Services.Database;
using eTouristAgencyAPI.Services.Database.Models;
using eTouristAgencyAPI.Services.Interfaces;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;

namespace eTouristAgencyAPI.Services
{
    public class OfferService : CRUDService<Offer, OfferResponse, OfferSearchModel, AddOfferRequest, UpdateOfferRequest>, IOfferService
    {
        private readonly IRoomService _roomService;
        private readonly IOfferDiscountService _offerDiscountService;
        private readonly Guid? _userId;

        public OfferService(eTouristAgencyDbContext dbContext,
                            IMapper mapper,
                            IUserContextService userContextService,
                            IRoomService roomService,
                            IOfferDiscountService offerDiscountService) : base(dbContext, mapper)
        {
            _roomService = roomService;
            _offerDiscountService = offerDiscountService;
            _userId = userContextService.GetUserId();
        }

        public override async Task<OfferResponse> AddAsync(AddOfferRequest insertModel)
        {
            var offerResponse = await base.AddAsync(insertModel);

            offerResponse.Rooms = await _roomService.AddByOfferIdAsync(offerResponse.Id, insertModel.Rooms);

            if (insertModel.OfferDiscounts != null && insertModel.OfferDiscounts.Any())
            {
                offerResponse.OfferDiscounts = await _offerDiscountService.AddByOfferIdAsync(offerResponse.Id, insertModel.OfferDiscounts);
            }

            return offerResponse;
        }

        protected override async Task BeforeInsertAsync(AddOfferRequest insertModel, Offer dbModel)
        {
            dbModel.Id = Guid.NewGuid();
            dbModel.CreatedBy = _userId ?? Guid.Empty;
            dbModel.ModifiedBy = _userId ?? Guid.Empty;
            dbModel.OfferStatusId = AppConstants.FixedOfferStatusDraft;
        }

        public override async Task<OfferResponse> UpdateAsync(Guid id, UpdateOfferRequest updateModel)
        {
            var offerResponse = await base.UpdateAsync(id, updateModel);

            if (offerResponse.OfferStatusId == AppConstants.FixedOfferStatusDraft)
            {
                offerResponse.Rooms = await _roomService.UpdateAsync(updateModel.Rooms);
                offerResponse.OfferDiscounts = await _offerDiscountService.UpdateAsync(updateModel.OfferDiscounts);
            }

            return offerResponse;
        }

        protected override async Task BeforeUpdateAsync(UpdateOfferRequest updateModel, Offer dbModel)
        {
            dbModel.ModifiedOn = DateTime.Now;
            dbModel.ModifiedBy = _userId ?? Guid.Empty;
        }

        protected override async Task<IQueryable<Offer>> BeforeFetchRecordAsync(IQueryable<Offer> queryable)
        {
            queryable = queryable.Include(x => x.Rooms).Include(x => x.OfferDiscounts);

            return queryable;
        }
    }
}
