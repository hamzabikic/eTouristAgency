using eTouristAgencyAPI.Models.RequestModels.EntityCodeValue;
using eTouristAgencyAPI.Models.ResponseModels.EntityCodeValue;
using eTouristAgencyAPI.Services.Constants;
using eTouristAgencyAPI.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eTouristAgencyAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EntityCodeValueController : ControllerBase
    {
        private readonly IEntityCodeValueService _entityCodeValueService;

        public EntityCodeValueController(IEntityCodeValueService entityCodeValueService)
        {
            _entityCodeValueService = entityCodeValueService;
        }

        [HttpGet("board-type")]
        public async Task<ActionResult<List<EntityCodeValueResponse>>> GetBoardTypeList()
        {
            try
            {
                var response = await _entityCodeValueService.GetAllByEntityCodeIdAsync(EntityCodes.BoardType);
                return Ok(response);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [Authorize(Roles = Roles.Admin)]
        [HttpPost("board-type")]
        public async Task<ActionResult> AddBoardType(AddUpdateEntityCodeValueRequest request)
        {
            try
            {
                await _entityCodeValueService.AddAsync(EntityCodes.BoardType, request);
                return Ok();
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [Authorize(Roles = Roles.Admin)]
        [HttpGet("discount-type")]
        public async Task<ActionResult<List<EntityCodeValueResponse>>> GetDiscountTypeList()
        {
            try
            {
                var response = await _entityCodeValueService.GetAllByEntityCodeIdAsync(EntityCodes.DiscountType);
                return Ok(response);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [Authorize(Roles = Roles.Admin)]
        [HttpGet("offer-status")]
        public async Task<ActionResult<EntityCodeValueResponse>> GetOfferStatusList()
        {
            try
            {
                var response = await _entityCodeValueService.GetAllByEntityCodeIdAsync(EntityCodes.OfferStatus);
                return Ok(response);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);

            }
        }

        [Authorize(Roles = Roles.Admin)]
        [HttpGet("reservation-status")]
        public async Task<ActionResult<EntityCodeValueResponse>> GetReservationStatusList()
        {
            try
            {
                var response = await _entityCodeValueService.GetAllByEntityCodeIdAsync(EntityCodes.ReservationStatus);
                return Ok(response);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);

            }
        }

        [Authorize(Roles = Roles.Admin)]
        [HttpPost("reservation-status")]
        public async Task<ActionResult> AddReservationStatus(AddUpdateEntityCodeValueRequest request)
        {
            try
            {
                await _entityCodeValueService.AddAsync(EntityCodes.ReservationStatus, request);
                return Ok();
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [Authorize(Roles = Roles.Admin)]
        [HttpPut("{id}")]
        public async Task<ActionResult> Update(Guid id, [FromBody] AddUpdateEntityCodeValueRequest updateModel)
        {
            try
            {
                await _entityCodeValueService.UpdateAsync(id, updateModel);
                return Ok();
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }
    }
}
