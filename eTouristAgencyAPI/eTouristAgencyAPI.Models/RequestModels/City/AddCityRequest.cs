namespace eTouristAgencyAPI.Models.RequestModels.City
{
    public class AddCityRequest
    {
        public string Name { get; set; }
        public Guid CountryId { get; set; }
    }
}
