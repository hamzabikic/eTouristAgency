namespace eTouristAgencyAPI.Models.RequestModels.Reservation
{
    public class AddReservationPaymentRequest
    {
        public byte[] DocumentBytes { get; set; }
        public string DocumentName { get; set; }
    }
}
