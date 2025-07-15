using eTouristAgencyAPI.Models.RequestModels.Hotel;
using eTouristAgencyAPI.Models.ResponseModels.Hotel;
using eTouristAgencyAPI.Models.SearchModels;
using eTouristAgencyAPI.Services.Constants;
using eTouristAgencyAPI.Services.Database.Models;
using eTouristAgencyAPI.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;

namespace eTouristAgencyAPI.Controllers
{
    [Authorize(Roles = Roles.Admin)]
    public class HotelController : CRUDController<Hotel, HotelResponse, HotelSearchModel, AddHotelRequest, UpdateHotelRequest>
    {
        public HotelController(IHotelService hotelService) : base(hotelService)
        {
        }
    }
}