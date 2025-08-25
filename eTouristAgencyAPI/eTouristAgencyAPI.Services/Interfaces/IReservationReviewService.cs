using eTouristAgencyAPI.Models.RequestModels.ReservationReview;
using eTouristAgencyAPI.Models.ResponseModels.ReservationReview;
using eTouristAgencyAPI.Models.SearchModels;
using eTouristAgencyAPI.Services.Database.Models;

namespace eTouristAgencyAPI.Services.Interfaces
{
    public interface IReservationReviewService : ICRUDService<ReservationReview, ReservationReviewResponse, ReservationReviewSearchModel, AddReservationReviewRequest, UpdateReservationReviewRequest>
    {

    }
}
