using eTouristAgencyAPI.Models.RequestModels.Offer;
using eTouristAgencyAPI.Models.ResponseModels.Offer;
using eTouristAgencyAPI.Models.SearchModels;
using eTouristAgencyAPI.Services.Database;
using eTouristAgencyAPI.Services.Database.Models;
using eTouristAgencyAPI.Services.Interfaces;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;

namespace eTouristAgencyAPI.Services
{
    public class OfferService : CRUDService<Offer, OfferResponse, OfferSearchModel, AddOfferRequest, UpdateOfferRequest>, IOfferService
    {
        private readonly BaseOfferStatusService _baseOfferStatusService;

        public OfferService(eTouristAgencyDbContext dbContext, IMapper mapper, BaseOfferStatusService baseOfferStatusService) : base(dbContext, mapper)
        {
            _baseOfferStatusService = baseOfferStatusService;
        }

        public override async Task<OfferResponse> AddAsync(AddOfferRequest insertModel)
        {
            var service = await _baseOfferStatusService.GetServiceAsync();

            return await service.AddAsync(insertModel);
        }

        public override async Task<OfferResponse> UpdateAsync(Guid id, UpdateOfferRequest updateModel)
        {
            var offer = await _dbContext.Offers.FindAsync(id);

            if (offer == null) throw new Exception("Offer with provided id is not found.");

            var service = await _baseOfferStatusService.GetServiceAsync(offer.OfferStatusId);

            return await service.UpdateAsync(id, updateModel);
        }

        public async Task ActivateAsync(Guid id)
        {
            var offer = await _dbContext.Offers.FindAsync(id);

            if (offer == null) throw new Exception("Offer with provided id is not found.");

            var service = await _baseOfferStatusService.GetServiceAsync(offer.OfferStatusId);

            await service.ActivateAsync(id);
        }

        public async Task DeactivateAsync(Guid id)
        {
            var offer = await _dbContext.Offers.FindAsync(id);

            if (offer == null) throw new Exception("Offer with provided id is not found.");

            var service = await _baseOfferStatusService.GetServiceAsync(offer.OfferStatusId);

            await service.DeactivateAsync(id);
        }

        protected override async Task<IQueryable<Offer>> BeforeFetchRecordAsync(IQueryable<Offer> queryable)
        {
            queryable = queryable.Include(x => x.Rooms).Include(x => x.OfferDiscounts);

            return queryable;
        }

        protected override async Task<IQueryable<Offer>> BeforeFetchAllDataAsync(IQueryable<Offer> queryable, OfferSearchModel searchModel)
        {
            queryable = queryable.Include(x => x.Hotel.City.Country).Include(x => x.Rooms).ThenInclude(x => x.RoomType).Include(x => x.BoardType).Include(x => x.OfferStatus);

            if (searchModel.OfferNo != null)
            {
                queryable = queryable.Where(x => x.OfferNo.ToString() == searchModel.OfferNo);
            }

            if (searchModel.BoardTypeId != null)
            {
                queryable = queryable.Where(x => x.BoardTypeId == searchModel.BoardTypeId);
            }

            if (searchModel.CountryId != null)
            {
                queryable = queryable.Where(x => x.Hotel.City.CountryId == searchModel.CountryId);
            }

            if (searchModel.OfferPriceFrom != null)
            {
                queryable = queryable.Where(x => x.Rooms.Min(x => x.PricePerPerson) >= searchModel.OfferPriceFrom);
            }

            if (searchModel.OfferPriceTo != null)
            {
                queryable = queryable.Where(x => x.Rooms.Min(x => x.PricePerPerson) <= searchModel.OfferPriceTo);
            }

            if (searchModel.OfferDateFrom != null)
            {
                queryable = queryable.Where(x => x.TripStartDate >= searchModel.OfferDateFrom);
            }

            if (searchModel.OfferDateTo != null)
            {
                queryable = queryable.Where(x => x.TripEndDate <= searchModel.OfferDateTo);
            }

            if (searchModel.OfferStatusId != null)
            {
                queryable = queryable.Where(x => x.OfferStatusId == searchModel.OfferStatusId);
            }

            return queryable;
        }
    }
}
