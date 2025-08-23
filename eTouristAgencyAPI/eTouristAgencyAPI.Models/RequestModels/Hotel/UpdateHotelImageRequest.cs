using System.Text.Json.Serialization;

namespace eTouristAgencyAPI.Models.RequestModels.Hotel
{
    public class UpdateHotelImageRequest
    {
        public Guid? Id { get; set; }
        public byte[] ImageBytes { get; set; }
        public string ImageName { get; set; }

        [JsonIgnore]
        public int DisplayOrderWithinHotel { get; set; }
    }
}