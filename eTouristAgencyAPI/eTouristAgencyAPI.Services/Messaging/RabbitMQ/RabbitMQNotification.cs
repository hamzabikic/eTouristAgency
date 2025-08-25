using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eTouristAgencyAPI.Services.Messaging.RabbitMQ
{
    public class RabbitMQNotification
    {
        public RabbitMQEmailNotification EmailNotification { get; set; }
        public RabbitMQFirebaseNotification FirebaseNotification { get; set; }
    }
}