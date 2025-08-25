namespace eTouristAgencyAPI.Models.RequestModels.ReservationReview
{
    public class AddReservationReviewRequest
    {
        public Guid Id { get; set; }

        public int AccommodationRating { get; set; }

        public int ServiceRating { get; set; }

        public string Description { get; set; }
    }
}
