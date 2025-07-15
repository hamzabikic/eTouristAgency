using eTouristAgencyAPI.Models.ResponseModels.User;

namespace eTouristAgencyAPI.Models.ResponseModels.Country
{
    public class CountryResponse
    {
        public Guid Id { get; set; }

        public string Name { get; set; }

        public DateTime CreatedOn { get; set; }

        public DateTime ModifiedOn { get; set; }

        public Guid? CreatedBy { get; set; }

        public Guid? ModifiedBy { get; set; }
    }
}
