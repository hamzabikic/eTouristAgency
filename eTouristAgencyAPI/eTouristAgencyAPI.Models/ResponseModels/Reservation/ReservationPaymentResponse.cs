namespace eTouristAgencyAPI.Models.ResponseModels.Reservation
{
    public class ReservationPaymentResponse
    {
        public Guid Id { get; set; }
        public byte[] DocumentBytes { get; set; }
        public string DocumentName { get; set; }
    }
}
