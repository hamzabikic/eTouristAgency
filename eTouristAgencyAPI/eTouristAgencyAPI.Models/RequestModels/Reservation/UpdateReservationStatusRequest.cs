namespace eTouristAgencyAPI.Models.RequestModels.Reservation
{
    public class UpdateReservationStatusRequest
    {
        public Guid ReservationStatusId { get; set; }
        public decimal PaidAmount { get; set; }
    }
}
