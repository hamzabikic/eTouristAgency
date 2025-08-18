using eTouristAgencyAPI.Models.RequestModels.Reservation;
using eTouristAgencyAPI.Models.ResponseModels.Reservation;
using eTouristAgencyAPI.Models.SearchModels;
using eTouristAgencyAPI.Services.Database.Models;

namespace eTouristAgencyAPI.Services.Interfaces
{
    public interface IReservationService : ICRUDService<Reservation, ReservationResponse, ReservationSearchModel, AddReservationRequest, UpdateReservationRequest>
    {
        Task ChangeStatusAsync(Guid reservationId, UpdateReservationStatusRequest request);
    }
}
