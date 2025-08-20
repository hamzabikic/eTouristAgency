using eTouristAgencyAPI.Models.RequestModels.Offer;
using eTouristAgencyAPI.Models.ResponseModels;
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
        private readonly BaseOfferStatusService _baseOfferStatusService;
        private readonly IUserContextService _userContextService;

        public OfferService(eTouristAgencyDbContext dbContext, IMapper mapper, BaseOfferStatusService baseOfferStatusService, IUserContextService userContextService) : base(dbContext, mapper)
        {
            _baseOfferStatusService = baseOfferStatusService;
            _userContextService = userContextService;
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

        public async Task<byte[]> GetImageAsync(Guid id)
        {
            var offerImage = await _dbContext.OfferImages.FindAsync(id);

            if (offerImage == null) throw new Exception("Image is not found.");

            return offerImage.ImageBytes;
        }

        protected override async Task<IQueryable<Offer>> BeforeFetchRecordAsync(IQueryable<Offer> queryable)
        {
            queryable = queryable.Include(x => x.Hotel.City.Country)
                                 .Include(x => x.Rooms).ThenInclude(x => x.RoomType)
                                 .Include(x => x.Rooms).ThenInclude(x => x.Reservations)
                                 .Include(x => x.BoardType)
                                 .Include(x => x.OfferStatus)
                                 .Include(x => x.OfferDiscounts).ThenInclude(x => x.DiscountType)
                                 .Include(x => x.OfferDocument)
                                 .Include(x => x.OfferImage);

            return queryable;
        }

        public override async Task<OfferResponse> GetByIdAsync(Guid id)
        {
            var offer = await _dbContext.Offers.FindAsync(id);

            if (offer == null || (offer.OfferStatusId != AppConstants.FixedOfferStatusActive && offer.OfferStatusId != AppConstants.FixedOfferStatusInactive))
            {
                throw new Exception("Offer with provided id is not found.");
            }

            return await base.GetByIdAsync(id);
        }

        protected override async Task<IQueryable<Offer>> BeforeFetchAllDataAsync(IQueryable<Offer> queryable, OfferSearchModel searchModel)
        {
            queryable = queryable.Include(x => x.Hotel.City.Country)
                                 .Include(x => x.Rooms).ThenInclude(x => x.RoomType)
                                 .Include(x => x.Rooms).ThenInclude(x => x.Reservations)
                                 .Include(x => x.BoardType)
                                 .Include(x => x.OfferStatus)
                                 .Include(x => x.OfferDiscounts).ThenInclude(x => x.DiscountType)
                                 .Include(x => x.OfferDocument)
                                 .Include(x => x.OfferImage);

            if (!_userContextService.UserHasRole(Roles.Admin) && searchModel.OfferStatusId != null && searchModel.OfferStatusId != AppConstants.FixedOfferStatusActive)
            {
                throw new Exception("Provided status is not avalible for this user.");
            }

            if (!_userContextService.UserHasRole(Roles.Admin) && searchModel.OfferStatusId == null)
            {
                searchModel.OfferStatusId = AppConstants.FixedOfferStatusActive;
            }

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

            if (searchModel.IsBookableNow)
            {
                queryable = queryable.Where(x => DateTime.Now.Date <= x.LastPaymentDeadline);
            }

            if (searchModel.IsLastMinuteDiscountActive)
            {
                queryable = queryable.Where(x => x.OfferDiscounts.Any(y => y.DiscountTypeId == AppConstants.FixedOfferDiscountTypeLastMinute && y.ValidFrom <= DateTime.Now.Date && y.ValidTo >= DateTime.Now.Date));
            }

            queryable = queryable.OrderByDescending(x => x.CreatedOn);

            return queryable;
        }

        protected override async Task AfterFetchAllDataAsync(List<Offer> listOfRecords)
        {
            foreach (var x in listOfRecords)
            {
                await AfterFetchRecordAsync(x);
            }
        }

        protected override async Task AfterFetchRecordAsync(Offer dbModel)
        {
            var firstMinuteDiscount = dbModel.OfferDiscounts.Where(y => y.DiscountTypeId == AppConstants.FixedOfferDiscountTypeFirstMinute && y.ValidFrom <= DateTime.Now.Date && y.ValidTo >= DateTime.Now.Date).FirstOrDefault();
            var lastMinuteDiscount = dbModel.OfferDiscounts.Where(y => y.DiscountTypeId == AppConstants.FixedOfferDiscountTypeLastMinute && y.ValidFrom <= DateTime.Now.Date && y.ValidTo >= DateTime.Now.Date).FirstOrDefault();
            var discount = firstMinuteDiscount?.Discount ?? lastMinuteDiscount?.Discount ?? 0;

            dbModel.IsLastMinuteDiscountActive = lastMinuteDiscount != null;
            dbModel.IsFirstMinuteDiscountActive = firstMinuteDiscount != null;

            var minPricePerPerson = dbModel.Rooms.Min(y => y.PricePerPerson);

            dbModel.MinimumPricePerPerson = minPricePerPerson - minPricePerPerson * (discount / 100);
            var quantity = dbModel.Rooms.Sum(x => x.Quantity * x.RoomType.RoomCapacity);
            var reservedQuantity = dbModel.Rooms.Where(x => x.Reservations.Any()).Sum(x => x.Reservations.Count * x.RoomType.RoomCapacity);

            dbModel.RemainingSpots = quantity - reservedQuantity;

            foreach (var item in dbModel.Rooms)
            {
                item.IsAvalible = item.Reservations.Count() < item.Quantity;
                item.DiscountedPrice = item.PricePerPerson - item.PricePerPerson * (discount / 100);
            }
        }
    }
}
