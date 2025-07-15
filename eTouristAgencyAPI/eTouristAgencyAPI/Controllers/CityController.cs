using eTouristAgencyAPI.Models.RequestModels.City;
using eTouristAgencyAPI.Models.ResponseModels.City;
using eTouristAgencyAPI.Models.SearchModels;
using eTouristAgencyAPI.Services.Constants;
using eTouristAgencyAPI.Services.Database.Models;
using eTouristAgencyAPI.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;

namespace eTouristAgencyAPI.Controllers
{
    [Authorize(Roles = Roles.Admin)]
    public class CityController : CRUDController<City, CityResponse, CitySearchModel, AddCityRequest, UpdateCityRequest>
    {
        public CityController(ICityService cityService) : base(cityService)
        {
        }
    }
}
