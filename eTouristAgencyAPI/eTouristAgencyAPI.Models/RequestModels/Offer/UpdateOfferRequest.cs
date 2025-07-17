using eTouristAgencyAPI.Models.RequestModels.OfferDiscount;
using eTouristAgencyAPI.Models.RequestModels.Room;

namespace eTouristAgencyAPI.Models.RequestModels.Offer
{
    public class UpdateOfferRequest
    {
        public DateTime TripStartDate { get; set; }

        public int NumberOfNights { get; set; }

        public DateTime TripEndDate { get; set; }

        public string Carriers { get; set; }

        public string Description { get; set; }

        public DateTime FirstPaymentDeadline { get; set; }

        public DateTime LastPaymentDeadline { get; set; }

        public string DeparturePlace { get; set; }

        public Guid HotelId { get; set; }

        public Guid BoardTypeId { get; set; }

        public byte[]? OfferImageBytes { get; set; }

        public byte[]? OfferDocumentBytes { get; set; }

        public List<UpdateRoomRequest> Rooms { get; set; } = new List<UpdateRoomRequest>();

        public List<UpdateOfferDiscountRequest> OfferDiscounts { get; set; } = new List<UpdateOfferDiscountRequest>();
    }
}
