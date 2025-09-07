namespace eTouristAgencyAPI.Services.Messaging.Firebase
{
    public class FirebaseNotificationData
    {
        public string ScreenName { get; set; }
        public Guid OfferId { get; set; }
        public Guid? RoomId { get; set; }
        public Guid? ReservationId { get; set; }
    }
}