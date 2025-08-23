using eTouristAgencyAPI.Models.RequestModels.Passenger;
using eTouristAgencyAPI.Models.ResponseModels.Passenger;

namespace eTouristAgencyAPI.Services.Interfaces
{
    public interface IPassengerService
    {
        Task<List<PassengerResponse>> AddByReservationIdAsync(Guid reservationId, List<AddPassengerRequest> passengerList);
        Task<List<PassengerResponse>> UpdateByReservationIdAsync(Guid reservationId, List<UpdatePassengerRequest> passengerList);
    }
}
