using eTouristAgencyAPI.Models.RequestModels.Passenger;

namespace eTouristAgencyAPI.Models.RequestModels.Reservation
{
    public class AddReservationRequest
    {
        public Guid RoomId { get; set; }
        public List<AddPassengerRequest> PassengerList { get; set; }
        public string? Note { get; set; }
    }
}
