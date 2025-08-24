using System.Net.Mail;

namespace eTouristAgencyAPI.Services.Messaging.RabbitMQ
{
    public class RabbitMQEmailNotification
    {
        public string Title { get; set; }
        public string Html { get; set; }
        public byte[]? AdditionalImage { get; set; }
        public List<string> Recipients { get; set; }
    }
}
