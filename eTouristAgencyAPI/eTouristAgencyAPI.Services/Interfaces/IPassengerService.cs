using eTouristAgencyAPI.Models.RequestModels.Passenger;
using eTouristAgencyAPI.Models.ResponseModels.Passenger;
using eTouristAgencyAPI.Services.Database.Models;
using eTouristAgencyAPI.Services.DTOs;

namespace eTouristAgencyAPI.Services.Interfaces
{
    public interface IPassengerService
    {
        Task<List<PassengerResponse>> AddByReservationIdAsync(Guid reservationId, List<AddPassengerRequest> passengerList);
        Task<List<PassengerResponse>> UpdateByReservationIdAsync(Guid reservationId, List<UpdatePassengerRequest> passengerList);
        Task<PassengerDocument> GetDocumentByIdAsync(Guid id);
        Task<PassengersDocumentDTO> GetDocumentOfPassengersByOfferIdAsync(Guid offerId);
    }
}
