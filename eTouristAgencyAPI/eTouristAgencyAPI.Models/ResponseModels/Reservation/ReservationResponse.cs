using eTouristAgencyAPI.Models.ResponseModels.EntityCodeValue;
using eTouristAgencyAPI.Models.ResponseModels.OfferDiscount;
using eTouristAgencyAPI.Models.ResponseModels.Passenger;
using eTouristAgencyAPI.Models.ResponseModels.Room;
using eTouristAgencyAPI.Models.ResponseModels.User;

namespace eTouristAgencyAPI.Models.ResponseModels.Reservation
{
    public class ReservationResponse
    {
        public Guid Id { get; set; }

        public Guid UserId { get; set; }

        public DateTime CreatedOn { get; set; }

        public DateTime ModifiedOn { get; set; }

        public decimal PaidAmount { get; set; }

        public DateTime CancellationDate { get; set; }

        public long ReservationNo { get; set; }

        public decimal TotalCost { get; set; }

        public Guid? OfferDiscountId { get; set; }

        public Guid ReservationStatusId { get; set; }

        public Guid RoomId { get; set; }

        public RoomResponse Room { get; set; }

        public OfferDiscountResponse OfferDiscount { get; set; }

        public List<PassengerResponse> Passengers { get; set; }

        public List<ReservationPaymentResponse> ReservationPayments { get; set; }

        public EntityCodeValueResponse ReservationStatus { get; set; }

        public UserResponse User { get; set; }
    }
}
