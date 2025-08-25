using eTouristAgencyAPI.Models.RequestModels.ReservationReview;
using eTouristAgencyAPI.Models.ResponseModels.ReservationReview;
using eTouristAgencyAPI.Models.SearchModels;
using eTouristAgencyAPI.Services.Constants;
using eTouristAgencyAPI.Services.Database;
using eTouristAgencyAPI.Services.Database.Models;
using eTouristAgencyAPI.Services.Interfaces;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;

namespace eTouristAgencyAPI.Services
{
    public class ReservationReviewService : CRUDService<ReservationReview, ReservationReviewResponse, ReservationReviewSearchModel, AddReservationReviewRequest, UpdateReservationReviewRequest>, IReservationReviewService
    {
        private readonly IUserContextService _userContextService;
        private readonly Guid? _userId;

        public ReservationReviewService(eTouristAgencyDbContext dbContext, IMapper mapper, IUserContextService userContextService) : base(dbContext, mapper)
        {
            _userContextService = userContextService;
            _userId = userContextService.GetUserId();
        }

        protected override async Task BeforeInsertAsync(AddReservationReviewRequest insertModel, ReservationReview dbModel)
        {
            var reservation = await _dbContext.Reservations.Include(x => x.Room.Offer).Include(x => x.ReservationReview).Include(x=> x.User).FirstOrDefaultAsync(x => x.Id == insertModel.Id);

            if (reservation == null)
            {
                throw new Exception("Reservation with provided id is not found.");
            }

            if (reservation.ReservationReview != null)
            {
                throw new Exception("You have already sent review.");
            }

            if (reservation.UserId != _userId)
            {
                throw new Exception("You can only add review on your reservation.");
            }

            if (!reservation.User.IsVerified)
            {
                throw new Exception("You have to verify your email for this action.");
            }

            if (reservation.ReservationStatusId == AppConstants.FixedReservationStatusCancelled)
            {
                throw new Exception("Reservation with provided id is cancelled.");
            }

            if (reservation.Room.Offer.OfferStatusId == AppConstants.FixedOfferStatusInactive)
            {
                throw new Exception("You cannot add review for inactive offer.");
            }

            if (reservation.Room.Offer.TripEndDate.Date > DateTime.Now.Date)
            {
                throw new Exception("You cannot add review before end of trip.");
            }

            dbModel.CreatedBy = _userId ?? Guid.Empty;
            dbModel.ModifiedBy = _userId ?? Guid.Empty;
        }

        public override Task<ReservationReviewResponse> UpdateAsync(Guid id, UpdateReservationReviewRequest updateModel)
        {
            throw new Exception("This method is not implemented.");
        }

        protected override async Task<IQueryable<ReservationReview>> BeforeFetchAllDataAsync(IQueryable<ReservationReview> queryable, ReservationReviewSearchModel searchModel)
        {
            queryable = queryable.Include(x => x.IdNavigation.User).Include(x => x.IdNavigation.Room);

            if (searchModel.OfferId != null)
            {
                queryable = queryable.Where(x => x.IdNavigation.Room.OfferId == searchModel.OfferId);
            }

            return queryable;
        }

        protected override async Task<IQueryable<ReservationReview>> BeforeFetchRecordAsync(IQueryable<ReservationReview> queryable)
        {
            queryable = queryable.Include(x => x.IdNavigation.User);

            return queryable;
        }

        public override async Task<ReservationReviewResponse> GetByIdAsync(Guid id)
        {
            var reservationReviewResponse = await base.GetByIdAsync(id);

            if (!_userContextService.UserHasRole(Roles.Admin) && reservationReviewResponse.IdNavigation.UserId != _userId)
            {
                throw new Exception("You can only fetch your reviews.");
            }

            return reservationReviewResponse;
        }
    }
}
