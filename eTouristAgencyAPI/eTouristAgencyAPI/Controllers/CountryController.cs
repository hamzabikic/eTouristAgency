using eTouristAgencyAPI.Models.RequestModels.Country;
using eTouristAgencyAPI.Models.ResponseModels.Country;
using eTouristAgencyAPI.Models.SearchModels;
using eTouristAgencyAPI.Services.Constants;
using eTouristAgencyAPI.Services.Database.Models;
using eTouristAgencyAPI.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eTouristAgencyAPI.Controllers
{
    [Authorize]
    public class CountryController : CRUDController<Country, CountryResponse, CountrySearchModel, AddCountryRequest, UpdateCountryRequest>
    {
        public CountryController(ICountryService countryService) : base(countryService)
        {
        }

        [Authorize(Roles = Roles.Admin)]
        public override Task<ActionResult<CountryResponse>> Add([FromBody] AddCountryRequest insertModel)
        {
            return base.Add(insertModel);
        }

        [Authorize(Roles = Roles.Admin)]
        public override Task<ActionResult<CountryResponse>> Update(Guid id, [FromBody] UpdateCountryRequest updateModel)
        {
            return base.Update(id, updateModel);
        }
    }
}
