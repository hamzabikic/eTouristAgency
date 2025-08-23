using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eTouristAgencyAPI.Models.RequestModels.Hotel
{
    public class AddHotelImageRequest
    {
        public byte[] ImageBytes { get; set; }
        public string ImageName { get; set; }
    }
}
