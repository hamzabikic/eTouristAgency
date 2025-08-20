using eTouristAgencyAPI.Models.RequestModels.Reservation;
using eTouristAgencyAPI.Models.ResponseModels;
using eTouristAgencyAPI.Models.ResponseModels.Reservation;
using eTouristAgencyAPI.Models.SearchModels;
using eTouristAgencyAPI.Services.Constants;
using eTouristAgencyAPI.Services.Database.Models;
using eTouristAgencyAPI.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eTouristAgencyAPI.Controllers
{
    public class ReservationController : CRUDController<Reservation, ReservationResponse, ReservationSearchModel, AddReservationRequest, UpdateReservationRequest>
    {
        private readonly IReservationService _reservationService;

        public ReservationController(IReservationService reservationService) : base(reservationService)
        {
            _reservationService = reservationService;
        }

        [Authorize(Roles = Roles.Client)]
        public override Task<ActionResult<ReservationResponse>> Add([FromBody] AddReservationRequest insertModel)
        {
            return base.Add(insertModel);
        }

        [Authorize(Roles = Roles.Client)]
        public override Task<ActionResult<ReservationResponse>> Update(Guid id, [FromBody] UpdateReservationRequest updateModel)
        {
            return base.Update(id, updateModel);
        }

        [Authorize(Roles = Roles.Admin)]
        public override Task<ActionResult<PaginatedList<ReservationResponse>>> GetAll([FromQuery] ReservationSearchModel searchModel)
        {
            return base.GetAll(searchModel);
        }

        [Authorize(Roles = Roles.Admin)]
        [HttpPatch("{id}/status")]
        public async Task<ActionResult> ChangeStatus(Guid id, [FromBody] UpdateReservationStatusRequest request)
        {
            try
            {
                await _reservationService.ChangeStatusAsync(id, request);
                return Ok();
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [Authorize(Roles = Roles.Client)]
        [HttpGet("me")]
        public async Task<ActionResult<PaginatedList<MyReservationResponse>>> GetAllForCurrentUser([FromQuery] MyReservationSearchModel searchModel)
        {
            try
            {
                return Ok(await _reservationService.GetAllForCurrentUserAsync(searchModel));
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }
    }
}
