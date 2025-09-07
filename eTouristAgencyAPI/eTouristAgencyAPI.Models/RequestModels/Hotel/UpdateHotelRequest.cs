namespace eTouristAgencyAPI.Models.RequestModels.Hotel
{
    public class UpdateHotelRequest
    {
        public string Name { get; set; }
        public Guid CityId { get; set; }
        public int StarRating { get; set; }
        public List<UpdateHotelImageRequest>? Images { get; set; } = new List<UpdateHotelImageRequest> { };
    }
}
