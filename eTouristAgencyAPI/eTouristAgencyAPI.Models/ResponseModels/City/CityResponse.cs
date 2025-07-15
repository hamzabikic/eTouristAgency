using eTouristAgencyAPI.Models.ResponseModels.Country;

namespace eTouristAgencyAPI.Models.ResponseModels.City
{
    public class CityResponse
    {
        public Guid Id { get; set; }

        public string Name { get; set; }

        public DateTime CreatedOn { get; set; }

        public DateTime ModifiedOn { get; set; }

        public Guid? CreatedBy { get; set; }

        public Guid? ModifiedBy { get; set; }

        public Guid CountryId { get; set; }

        public CountryResponse Country { get; set; }
    }
}
