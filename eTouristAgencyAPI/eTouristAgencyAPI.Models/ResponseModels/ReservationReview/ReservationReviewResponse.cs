using System.Text.Json.Serialization;

namespace eTouristAgencyAPI.Models.ResponseModels.ReservationReview
{
    public class ReservationReviewResponse
    {
        public Guid Id { get; set; }
        public int AccommodationRating { get; set; }
        public int ServiceRating { get; set; }
        public string Description { get; set; }
        public DateTime CreatedOn { get; set; }

        [JsonPropertyName("reservation")]
        public ReservationReviewReservationResponse IdNavigation { get; set; }
    }

    public class ReservationReviewReservationResponse
    {
        public int ReservationNo { get; set; }
        public Guid UserId { get; set; }
        public ReservationReviewUserResponse User { get; set; }
    }

    public class ReservationReviewUserResponse
    {
        public Guid Id { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
    }
}
