using eTouristAgencyAPI.Models.RequestModels.Country;
using eTouristAgencyAPI.Models.ResponseModels.Country;
using eTouristAgencyAPI.Models.SearchModels;
using eTouristAgencyAPI.Services.Database.Models;

namespace eTouristAgencyAPI.Services.Interfaces
{
    public interface ICountryService : ICRUDService<Country, CountryResponse, CountrySearchModel, AddCountryRequest, UpdateCountryRequest>
    {

    }
}
