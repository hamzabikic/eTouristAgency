using eTouristAgencyAPI.Models.RequestModels.RoomType;
using eTouristAgencyAPI.Models.ResponseModels.RoomType;
using eTouristAgencyAPI.Models.SearchModels;
using eTouristAgencyAPI.Services.Constants;
using eTouristAgencyAPI.Services.Database.Models;
using eTouristAgencyAPI.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eTouristAgencyAPI.Controllers
{
    public class RoomTypeController : CRUDController<RoomType, RoomTypeResponse, RoomTypeSearchModel, AddRoomTypeRequest, UpdateRoomTypeRequest>
    {
        public RoomTypeController(IRoomTypeService roomTypeService) : base(roomTypeService)
        {
        }

        [Authorize(Roles = Roles.Admin)]
        public override Task<ActionResult<RoomTypeResponse>> Add([FromBody] AddRoomTypeRequest insertModel)
        {
            return base.Add(insertModel);
        }

        [Authorize(Roles = Roles.Admin)]
        public override Task<ActionResult<RoomTypeResponse>> Update(Guid id, [FromBody] UpdateRoomTypeRequest updateModel)
        {
            return base.Update(id, updateModel);
        }
    }
}
