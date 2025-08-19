using eTouristAgencyAPI.Models.RequestModels.Reservation;
using eTouristAgencyAPI.Models.ResponseModels;
using eTouristAgencyAPI.Models.ResponseModels.Reservation;
using eTouristAgencyAPI.Models.SearchModels;
using eTouristAgencyAPI.Services.Constants;
using eTouristAgencyAPI.Services.Database;
using eTouristAgencyAPI.Services.Database.Models;
using eTouristAgencyAPI.Services.Interfaces;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;

namespace eTouristAgencyAPI.Services
{
    public class ReservationService : CRUDService<Reservation, ReservationResponse, ReservationSearchModel, AddReservationRequest, UpdateReservationRequest>, IReservationService
    {
        private readonly IPassengerService _passengerService;
        private readonly IUserContextService _userContextService;
        private readonly Guid? _userId;

        public ReservationService(eTouristAgencyDbContext dbContext,
                                  IMapper mapper,
                                  IUserContextService userContextService,
                                  IPassengerService passengerService) : base(dbContext, mapper)
        {
            _userId = userContextService.GetUserId();
            _userContextService = userContextService;
            _passengerService = passengerService;
        }

        protected override async Task BeforeInsertAsync(AddReservationRequest insertModel, Reservation dbModel)
        {
            var room = await _dbContext.Rooms.Include(x => x.RoomType)
                                             .Include(x => x.Offer)
                                             .ThenInclude(x => x.OfferDiscounts)
                                             .Include(x => x.Reservations)
                                             .FirstOrDefaultAsync(x => x.Id == dbModel.RoomId);

            if (room == null)
            {
                throw new Exception("Room with provided id is not found");
            }

            if (DateTime.Now.Date >= room.Offer.TripStartDate.Date || room.Offer.OfferStatusId != AppConstants.FixedOfferStatusActive)
            {
                throw new Exception("Currently it is not possible to reserve room with provided id.");
            }

            if (room.Reservations.Count() >= room.Quantity)
            {
                throw new Exception("Room with provided id is already included in other reservation");
            }

            var numberOfKids = insertModel.PassengerList.Where(x => x.DateOfBirth > DateTime.Now.AddYears(-18)).Count();
            var discount = room.Offer.OfferDiscounts.Where(x => x.ValidFrom.Date <= DateTime.Now.Date && DateTime.Now.Date <= x.ValidTo.Date).FirstOrDefault();
            var discountPercent = discount == null ? 0 : discount.Discount / 100;
            var kidsDiscountPercent = room.ChildDiscount / 100;
            var totalCostAdults = (room.RoomType.RoomCapacity - numberOfKids) * (room.PricePerPerson - room.PricePerPerson * discountPercent);
            var totalCostKids = numberOfKids * (room.PricePerPerson - room.PricePerPerson * (discountPercent + kidsDiscountPercent));
            var totalCost = totalCostAdults + totalCostKids;

            dbModel.Id = Guid.NewGuid();
            dbModel.ReservationStatusId = AppConstants.FixedReservationStatusNotPaid;
            dbModel.UserId = _userId ?? Guid.Empty;
            dbModel.CreatedBy = _userId ?? Guid.Empty;
            dbModel.ModifiedBy = _userId ?? Guid.Empty;
            dbModel.TotalCost = totalCost;
            dbModel.OfferDiscountId = discount?.Id;
        }

        public override async Task<ReservationResponse> AddAsync(AddReservationRequest insertModel)
        {
            var reservationResponse = await base.AddAsync(insertModel);
            reservationResponse.Passengers = await _passengerService.AddByReservationIdAsync(reservationResponse.Id, insertModel.PassengerList);

            return reservationResponse;
        }

        protected override async Task BeforeUpdateAsync(UpdateReservationRequest updateModel, Reservation dbModel)
        {
            if (dbModel.UserId != _userId) throw new Exception("You can only edit reservations created by yourself.");

            var numberOfKids = updateModel.PassengerList.Where(x => x.DateOfBirth > DateTime.Now.AddYears(-18)).Count();
            var discountPercent = dbModel.OfferDiscount == null ? 0 : dbModel.OfferDiscount.Discount / 100;
            var kidsDiscountPercent = dbModel.Room.ChildDiscount / 100;
            var totalCostAdults = (dbModel.Room.RoomType.RoomCapacity - numberOfKids) * (dbModel.Room.PricePerPerson - dbModel.Room.PricePerPerson * discountPercent);
            var totalCostKids = numberOfKids * (dbModel.Room.PricePerPerson - dbModel.Room.PricePerPerson * (discountPercent + kidsDiscountPercent));
            var totalCost = totalCostAdults + totalCostKids;

            dbModel.ModifiedOn = DateTime.Now;
            dbModel.ModifiedBy = _userId ?? Guid.Empty;
            dbModel.TotalCost = totalCost;

            if (updateModel.ReservationPaymentList != null && updateModel.ReservationPaymentList.Any())
            {
                updateModel.ReservationPaymentList.Select(x =>
                new ReservationPayment
                {
                    CreatedBy = _userId ?? Guid.Empty,
                    ModifiedBy = _userId ?? Guid.Empty,
                    DocumentBytes = x.DocumentBytes,
                    DocumentName = x.DocumentName
                }).ToList().ForEach(x =>
                {
                    dbModel.ReservationPayments.Add(x);
                });
            }
        }

        public override async Task<ReservationResponse> UpdateAsync(Guid id, UpdateReservationRequest updateModel)
        {
            var reservationRespone = await base.UpdateAsync(id, updateModel);
            reservationRespone.Passengers = await _passengerService.UpdateByReservationIdAsync(id, updateModel.PassengerList);

            return reservationRespone;
        }

        protected override async Task<IQueryable<Reservation>> BeforeFetchRecordAsync(IQueryable<Reservation> queryable)
        {
            queryable = queryable.Include(x => x.Room)
                                 .ThenInclude(x => x.RoomType)
                                 .Include(x => x.OfferDiscount)
                                 .Include(x => x.Passengers)
                                 .Include(x => x.ReservationPayments)
                                 .Include(x => x.ReservationStatus)
                                 .Include(x => x.User);

            return queryable;
        }

        protected override async Task<IQueryable<Reservation>> BeforeFetchAllDataAsync(IQueryable<Reservation> queryable, ReservationSearchModel searchModel)
        {
            queryable = queryable.Include(x => x.Room)
                                 .ThenInclude(x => x.RoomType)
                                 .Include(x => x.OfferDiscount)
                                 .Include(x => x.Passengers)
                                 .Include(x => x.ReservationPayments)
                                 .Include(x => x.ReservationStatus)
                                 .Include(x => x.User);

            if (searchModel.OfferId != null)
            {
                queryable = queryable.Where(x => x.Room.OfferId == searchModel.OfferId);
            }

            if (searchModel.ReservationStatusId != null)
            {
                queryable = queryable.Where(x => x.ReservationStatusId == searchModel.ReservationStatusId);
            }

            return queryable;
        }

        public override async Task<ReservationResponse> GetByIdAsync(Guid id)
        {
            var reservationResponse = await base.GetByIdAsync(id);

            if (!_userContextService.UserHasRole(Roles.Admin) && reservationResponse.UserId != _userId)
            {
                throw new Exception("Reservation with provided id is not avalible for this user.");
            }

            return reservationResponse;
        }

        public async Task ChangeStatusAsync(Guid reservationId, UpdateReservationStatusRequest request)
        {
            var reservation = await _dbContext.Reservations.FindAsync(reservationId);

            if (reservation == null)
            {
                throw new Exception("Reservation with provided id is not found.");
            }

            reservation.ReservationStatusId = request.ReservationStatusId;

            await _dbContext.SaveChangesAsync();
        }
    }
}
