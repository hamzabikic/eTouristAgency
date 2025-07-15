namespace eTouristAgencyAPI.Models.RequestModels.City
{
    public class UpdateCityRequest
    {
        public string Name { get; set; }
        public Guid CountryId { get; set; }
    }
}
