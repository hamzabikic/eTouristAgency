using eTouristAgencyAPI.Models.ResponseModels.EntityCodeValue;
using eTouristAgencyAPI.Models.ResponseModels.Hotel;
using eTouristAgencyAPI.Models.ResponseModels.OfferDiscount;
using eTouristAgencyAPI.Models.ResponseModels.Room;

namespace eTouristAgencyAPI.Models.ResponseModels.Offer
{
    public class OfferResponse
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

        public decimal MinimumPricePerPerson { get; set; }

        public bool IsFirstMinuteDiscountActive { get; set; }

        public bool IsLastMinuteDiscountActive { get; set; }

        public int RemainingSpots { get; set; }

        public bool IsEditable { get; set; }

        public bool IsReviewable { get; set; }

        public EntityCodeValueResponse BoardType { get; set; }

        public HotelResponse Hotel { get; set; }

        public List<OfferDiscountResponse> OfferDiscounts { get; set; }

        public EntityCodeValueResponse OfferStatus { get; set; }

        public List<RoomResponse> Rooms { get; set; }
    }
}
