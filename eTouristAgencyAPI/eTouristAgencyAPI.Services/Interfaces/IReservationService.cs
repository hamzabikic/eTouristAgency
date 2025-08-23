using eTouristAgencyAPI.Models.RequestModels.Reservation;
using eTouristAgencyAPI.Models.ResponseModels;
using eTouristAgencyAPI.Models.ResponseModels.Reservation;
using eTouristAgencyAPI.Models.SearchModels;
using eTouristAgencyAPI.Services.Database.Models;

namespace eTouristAgencyAPI.Services.Interfaces
{
    public interface IReservationService : ICRUDService<Reservation, ReservationResponse, ReservationSearchModel, AddReservationRequest, UpdateReservationRequest>
    {
        Task AddPaymentAsync(Guid reservationId, UpdateReservationStatusRequest request);
        Task CancelReservationAsync(Guid reservationId);
        Task<PaginatedList<MyReservationResponse>> GetAllForCurrentUserAsync(MyReservationSearchModel searchModel);
        Task<ReservationPayment> GetReservationPaymentByReservationPaymentIdAsync(Guid reservationPaymentId);
    }
}
