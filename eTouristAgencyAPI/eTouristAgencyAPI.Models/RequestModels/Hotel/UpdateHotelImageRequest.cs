namespace eTouristAgencyAPI.Models.RequestModels.Hotel
{
    public class UpdateHotelImageRequest
    {
        public Guid? Id { get; set; }
        public byte[] ImageBytes { get; set; }
    }
}