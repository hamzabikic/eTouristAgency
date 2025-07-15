using eTouristAgencyAPI.Models.RequestModels.City;
using eTouristAgencyAPI.Models.ResponseModels.City;
using eTouristAgencyAPI.Models.SearchModels;
using eTouristAgencyAPI.Services.Database.Models;

namespace eTouristAgencyAPI.Services.Interfaces
{
    public interface ICityService : ICRUDService<City, CityResponse, CitySearchModel, AddCityRequest, UpdateCityRequest>
    {
    }
}
