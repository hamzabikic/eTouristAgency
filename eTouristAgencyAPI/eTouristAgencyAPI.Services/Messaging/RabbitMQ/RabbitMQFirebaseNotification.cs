using eTouristAgencyAPI.Services.Messaging.Firebase;

namespace eTouristAgencyAPI.Services.Messaging.RabbitMQ
{
    public class RabbitMQFirebaseNotification
    {
        public string Title { get; set; }
        public string Text { get; set; }
        public FirebaseNotificationData Data { get; set; }
        public List<string> FirebaseTokens { get; set; }
    }
}
