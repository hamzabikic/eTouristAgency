using EasyNetQ;
using eTouristAgencyAPI.Models.RequestModels.Offer;
using eTouristAgencyAPI.Models.ResponseModels.Offer;
using eTouristAgencyAPI.Models.SearchModels;
using eTouristAgencyAPI.Services.Configuration;
using eTouristAgencyAPI.Services.Constants;
using eTouristAgencyAPI.Services.Database;
using eTouristAgencyAPI.Services.Database.Models;
using eTouristAgencyAPI.Services.Interfaces;
using eTouristAgencyAPI.Services.Messaging.Firebase;
using eTouristAgencyAPI.Services.Messaging.RabbitMQ;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;
using Newtonsoft.Json;

namespace eTouristAgencyAPI.Services
{
    public class OfferService : CRUDService<Offer, OfferResponse, OfferSearchModel, AddOfferRequest, UpdateOfferRequest>, IOfferService
    {
        private readonly BaseOfferStatusService _baseOfferStatusService;
        private readonly IUserContextService _userContextService;
        private readonly IOfferContentBasedService _offerContentBasedService;
        private readonly IEmailContentService _emailContentService;
        private readonly IBus _bus;

        public OfferService(eTouristAgencyDbContext dbContext,
                            IMapper mapper,
                            BaseOfferStatusService baseOfferStatusService,
                            IOfferContentBasedService offerContentBasedService,
                            IEmailContentService emailContentService,
                            IUserContextService userContextService,
                            IBus bus) : base(dbContext, mapper)
        {
            _baseOfferStatusService = baseOfferStatusService;
            _userContextService = userContextService;
            _offerContentBasedService = offerContentBasedService;
            _emailContentService = emailContentService;
            _bus = bus;
        }

        public override async Task<OfferResponse> AddAsync(AddOfferRequest insertModel)
        {
            var service = await _baseOfferStatusService.GetServiceAsync();
            var offerResponse = await service.AddAsync(insertModel);

            return offerResponse;
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
            await SendOfferNotificationsAsync(offer.Id);
        }

        private async Task SendOfferNotificationsAsync(Guid offerId)
        {
            var offer = await _dbContext.Offers.Include(x => x.BoardType)
                                               .Include(x => x.Hotel.City.Country)
                                               .Include(x => x.Rooms)
                                               .Include(x => x.OfferDiscounts)
                                               .Include(x => x.OfferImage)
                                               .FirstAsync(x => x.Id == offerId);

            var recipients = await _offerContentBasedService.GetUsersForOfferAsync(offer);

            var emailNotificationTitle = await _emailContentService.GetOfferRecommendationTitleAsync(offer);
            var emailNotificationText = await _emailContentService.GetOfferRecommendationTextAsync(offer);
            var emailNotification = new RabbitMQEmailNotification
            {
                Title = emailNotificationTitle,
                Html = emailNotificationText,
                AdditionalImage = offer.OfferImage?.ImageBytes,
                Recipients = recipients.Select(x => x.Email).ToList()
            };

            var recipientsWithToken = recipients.Where(x => x.FirebaseToken != null).ToList();

            var notificationTitle = "Napravili smo ponudu samo za Vas!";
            var notificationText = "Kliknite ovdje za više detalja.";

            var firebaseNotification = new RabbitMQFirebaseNotification
            {
                FirebaseTokens = recipientsWithToken.Select(x => x.FirebaseToken).ToList(),
                Title = notificationTitle,
                Text = notificationText,
                Data = new FirebaseNotificationData
                {
                    ScreenName = MobileAppScreenNames.OfferDetailsScreen,
                    OfferId = offerId
                }
            };

            _bus.PubSub.Publish(JsonConvert.SerializeObject(new RabbitMQNotification
            {
                EmailNotification = emailNotification,
                FirebaseNotification = firebaseNotification
            }));
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
            queryable = queryable.Include(x => x.Hotel.City.Country)
                                 .Include(x => x.Rooms.OrderBy(x => x.DisplayOrderWithinOffer)).ThenInclude(x => x.RoomType)
                                 .Include(x => x.Rooms.OrderBy(x => x.DisplayOrderWithinOffer)).ThenInclude(x => x.Reservations)
                                 .Include(x => x.BoardType)
                                 .Include(x => x.OfferStatus)
                                 .Include(x => x.OfferDiscounts).ThenInclude(x => x.DiscountType);

            return queryable;
        }

        public override async Task<OfferResponse> GetByIdAsync(Guid id)
        {
            var offer = await _dbContext.Offers.FindAsync(id);

            if (offer == null || (!_userContextService.UserHasRole(Roles.Admin) &&
                                  offer.OfferStatusId == AppConstants.FixedOfferStatusDraft))
            {
                throw new Exception("Offer with provided id is not found.");
            }

            return await base.GetByIdAsync(id);
        }

        public async Task<OfferImage> GetImageByIdAsync(Guid id)
        {
            var offerImage = await _dbContext.OfferImages.FindAsync(id);

            if (offerImage == null) throw new Exception("Offer with provided id does not have image.");

            return offerImage;
        }

        public async Task<OfferDocument> GetDocumentByIdAsync(Guid id)
        {
            var offerDocument = await _dbContext.OfferDocuments.FindAsync(id);

            if (offerDocument == null) throw new Exception("Offer with provided id does not have document.");

            return offerDocument;
        }

        protected override async Task<IQueryable<Offer>> BeforeFetchAllDataAsync(IQueryable<Offer> queryable, OfferSearchModel searchModel)
        {
            queryable = queryable.Include(x => x.Hotel.City.Country)
                                 .Include(x => x.Rooms.OrderBy(x => x.DisplayOrderWithinOffer)).ThenInclude(x => x.RoomType)
                                 .Include(x => x.Rooms.OrderBy(x => x.DisplayOrderWithinOffer)).ThenInclude(x => x.Reservations)
                                 .Include(x => x.BoardType)
                                 .Include(x => x.OfferStatus)
                                 .Include(x => x.OfferDiscounts).ThenInclude(x => x.DiscountType);

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
            dbModel.IsLastMinuteDiscountActive = lastMinuteDiscount != null;
            dbModel.IsFirstMinuteDiscountActive = firstMinuteDiscount != null;
            
            var discount = firstMinuteDiscount?.Discount ?? lastMinuteDiscount?.Discount ?? 0;
            var minPricePerPerson = dbModel.Rooms.Min(y => y.PricePerPerson);
            dbModel.MinimumPricePerPerson = minPricePerPerson - minPricePerPerson * (discount / 100);

            var quantity = dbModel.Rooms.Sum(x => x.Quantity * x.RoomType.RoomCapacity);
            var reservedQuantity = dbModel.Rooms.Where(x => x.Reservations.Any()).Sum(x => x.Reservations.Count(x => !AppConstants.ForbiddenReservationStatusForReservationUpdate.Contains(x.ReservationStatusId)) * x.RoomType.RoomCapacity);
            dbModel.RemainingSpots = quantity - reservedQuantity;

            dbModel.IsEditable = dbModel.OfferStatusId != AppConstants.FixedOfferStatusInactive &&
                                 dbModel.TripStartDate.Date > DateTime.Now.Date;

            dbModel.IsReviewable = dbModel.OfferStatusId != AppConstants.FixedOfferStatusInactive &&
                                   dbModel.TripEndDate.Date <= DateTime.Now.Date;

            foreach(var disc in dbModel.OfferDiscounts)
            {
                disc.IsEditable = dbModel.IsEditable && disc.ValidTo.Date >= DateTime.Now.Date;
                disc.IsRemovable = dbModel.IsEditable && disc.ValidFrom.Date > DateTime.Now.Date;
            }

            foreach (var item in dbModel.Rooms)
            {
                item.IsAvalible = item.Reservations.Count(x => x.ReservationStatusId != AppConstants.FixedReservationStatusCancelled) < item.Quantity;
                item.DiscountedPrice = item.PricePerPerson - item.PricePerPerson * (discount / 100);
            }
        }
    }
}