using eTouristAgencyAPI.Models.ResponseModels.EntityCodeValue;
using eTouristAgencyAPI.Models.ResponseModels.Hotel;
using eTouristAgencyAPI.Models.ResponseModels.Offer;
using eTouristAgencyAPI.Models.ResponseModels.RoomType;

namespace eTouristAgencyAPI.Models.ResponseModels.Reservation
{
    public class MyReservationResponse
    {
        public Guid Id { get; set; }

        public Guid UserId { get; set; }

        public DateTime CreatedOn { get; set; }

        public DateTime ModifiedOn { get; set; }

        public decimal PaidAmount { get; set; }

        public DateTime CancellationDate { get; set; }

        public long ReservationNo { get; set; }

        public decimal TotalCost { get; set; }

        public Guid OfferDiscountId { get; set; }

        public Guid ReservationStatusId { get; set; }

        public Guid RoomId { get; set; }

        public EntityCodeValueResponse ReservationStatus { get; set; }

        public MyRoomResponse Room { get; set; }
    }

    public class MyRoomResponse
    {
        public Guid Id { get; set; }

        public Guid RoomTypeId { get; set; }

        public Guid OfferId { get; set; }

        public decimal PricePerPerson { get; set; }

        public decimal ChildDiscount { get; set; }

        public int Quantity { get; set; }

        public string ShortDescription { get; set; }

        public RoomTypeResponse RoomType { get; set; }

        public MyOfferResponse Offer { get; set; }
    }

    public class MyOfferResponse
    {
        public Guid Id { get; set; }

        public DateTime TripStartDate { get; set; }

        public int NumberOfNights { get; set; }

        public DateTime TripEndDate { get; set; }

        public string Carriers { get; set; }

        public string Description { get; set; }

        public DateTime FirstPaymentDeadline { get; set; }

        public DateTime LastPaymentDeadline { get; set; }

        public long OfferNo { get; set; }

        public string DeparturePlace { get; set; }

        public Guid HotelId { get; set; }

        public Guid OfferStatusId { get; set; }

        public Guid? BoardTypeId { get; set; }

        public EntityCodeValueResponse BoardType { get; set; }

        public HotelResponse Hotel { get; set; }

        public OfferImageResponse OfferImage { get; set; }
    }
}
