using eTouristAgencyAPI.Models.ResponseModels.Country;

namespace eTouristAgencyAPI.Models.ResponseModels.City
{
    public class CityResponse
    {
        public Guid Id { get; set; }

        public string Name { get; set; }

        public Guid CountryId { get; set; }

        public CountryResponse Country { get; set; }
    }
}
