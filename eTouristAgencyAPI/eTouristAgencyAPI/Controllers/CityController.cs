using eTouristAgencyAPI.Models.RequestModels.City;
using eTouristAgencyAPI.Models.ResponseModels.City;
using eTouristAgencyAPI.Models.SearchModels;
using eTouristAgencyAPI.Services.Constants;
using eTouristAgencyAPI.Services.Database.Models;
using eTouristAgencyAPI.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eTouristAgencyAPI.Controllers
{
    [Authorize]
    public class CityController : CRUDController<City, CityResponse, CitySearchModel, AddCityRequest, UpdateCityRequest>
    {
        public CityController(ICityService cityService) : base(cityService)
        {
        }

        [Authorize(Roles = Roles.Admin)]
        public override Task<ActionResult<CityResponse>> Add([FromBody] AddCityRequest insertModel)
        {
            return base.Add(insertModel);
        }

        [Authorize(Roles = Roles.Admin)]
        public override Task<ActionResult<CityResponse>> Update(Guid id, [FromBody] UpdateCityRequest updateModel)
        {
            return base.Update(id, updateModel);
        }
    }
}
