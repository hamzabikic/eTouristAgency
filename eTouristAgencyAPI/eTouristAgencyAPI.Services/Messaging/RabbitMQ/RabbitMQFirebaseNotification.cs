using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eTouristAgencyAPI.Services.Messaging.RabbitMQ
{
    public class RabbitMQFirebaseNotification
    {
        public string Title { get; set; }
        public string Text { get; set; }
        public List<string> FirebaseTokens { get; set; }
    }
}
