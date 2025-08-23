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
        private readonly IHotelService _hotelService;

        public HotelController(IHotelService hotelService) : base(hotelService)
        {
            _hotelService = hotelService;
        }

        [Authorize(Roles = Roles.Admin)]
        public override Task<ActionResult> Add([FromBody] AddHotelRequest insertModel)
        {
            return base.Add(insertModel);
        }

        [Authorize(Roles = Roles.Admin)]
        public override Task<ActionResult> Update(Guid id, [FromBody] UpdateHotelRequest updateModel)
        {
            return base.Update(id, updateModel);
        }

        [AllowAnonymous]
        [HttpGet("{hotelImageId}/image")]
        public async Task<ActionResult> GetHotelImage(Guid hotelImageId)
        {
            try
            {
                var hotelImage = await _hotelService.GetImageByHotelImageIdAsync(hotelImageId);

                Response.Headers.Add("ImageName", hotelImage.ImageName);
                return File(hotelImage.ImageBytes, "application/octet-stream", hotelImage.ImageName);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }
    }
}