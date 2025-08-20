using eTouristAgencyAPI.Models.RequestModels.Passenger;

namespace eTouristAgencyAPI.Models.RequestModels.Reservation
{
    public class UpdateReservationRequest
    {
        public List<UpdatePassengerRequest> PassengerList { get; set; }
        public List<AddReservationPaymentRequest>? ReservationPaymentList { get; set; }
    }
}
