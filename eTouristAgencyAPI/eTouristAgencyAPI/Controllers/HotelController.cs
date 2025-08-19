using eTouristAgencyAPI.Models.RequestModels.Hotel;
using eTouristAgencyAPI.Models.ResponseModels.Hotel;
using eTouristAgencyAPI.Models.SearchModels;
using eTouristAgencyAPI.Services.Constants;
using eTouristAgencyAPI.Services.Database.Models;
using eTouristAgencyAPI.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eTouristAgencyAPI.Controllers
{
    public class HotelController : CRUDController<Hotel, HotelResponse, HotelSearchModel, AddHotelRequest, UpdateHotelRequest>
    {
        public HotelController(IHotelService hotelService) : base(hotelService)
        {
        }

        [Authorize(Roles = Roles.Admin)]
        public override Task<ActionResult<HotelResponse>> Add([FromBody] AddHotelRequest insertModel)
        {
            return base.Add(insertModel);
        }

        [Authorize(Roles = Roles.Admin)]
        public override Task<ActionResult<HotelResponse>> Update(Guid id, [FromBody] UpdateHotelRequest updateModel)
        {
            return base.Update(id, updateModel);
        }
    }
}