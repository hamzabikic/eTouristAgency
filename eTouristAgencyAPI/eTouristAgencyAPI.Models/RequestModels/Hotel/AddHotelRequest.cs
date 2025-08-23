namespace eTouristAgencyAPI.Models.RequestModels.Hotel
{
    public class AddHotelRequest
    {
        public string Name { get; set; }
        public Guid CityId { get; set; }
        public int StarRating { get; set; }
        public List<AddHotelImageRequest>? Images { get; set; }
    }
}
