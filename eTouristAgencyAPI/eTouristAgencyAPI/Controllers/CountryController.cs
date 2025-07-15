using eTouristAgencyAPI.Models.RequestModels.Country;
using eTouristAgencyAPI.Models.ResponseModels.Country;
using eTouristAgencyAPI.Models.SearchModels;
using eTouristAgencyAPI.Services.Constants;
using eTouristAgencyAPI.Services.Database.Models;
using eTouristAgencyAPI.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;

namespace eTouristAgencyAPI.Controllers
{
    [Authorize(Roles = Roles.Admin)]
    public class CountryController : CRUDController<Country, CountryResponse, CountrySearchModel, AddCountryRequest, UpdateCountryRequest>
    {
        public CountryController(ICountryService countryService) : base(countryService)
        {
        }
    }
}
