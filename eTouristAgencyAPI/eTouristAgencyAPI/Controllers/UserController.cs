using eTouristAgencyAPI.Models.RequestModels.User;
using eTouristAgencyAPI.Models.ResponseModels;
using eTouristAgencyAPI.Models.ResponseModels.User;
using eTouristAgencyAPI.Models.SearchModels;
using eTouristAgencyAPI.Services.Constants;
using eTouristAgencyAPI.Services.Database.Models;
using eTouristAgencyAPI.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eTouristAgencyAPI.Controllers
{
    public class UserController : CRUDController<User, UserResponse, UserSearchModel, AddUserRequest, UpdateUserRequest>
    {
        private readonly IUserService _service;

        private readonly Guid? _userId;

        public UserController(IUserService userService, IUserContextService userContextService) : base(userService)
        {
            _service = userService;

            _userId = userContextService.GetUserId();
        }

        [AllowAnonymous]
        public override Task<ActionResult<UserResponse>> Add([FromBody] AddUserRequest insertModel)
        {
            return base.Add(insertModel);
        }

        [Authorize(Roles = Roles.Admin)]
        public override async Task<ActionResult<PaginatedList<UserResponse>>> GetAll([FromQuery] UserSearchModel searchModel)
        {
            return await base.GetAll(searchModel);
        }

        [AllowAnonymous]
        [HttpGet("exists")]
        public async Task<ActionResult<bool>> Exists(string? email, string? username)
        {
            try
            {
                return Ok(await _service.ExistsAsync(username, email));
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [HttpGet("me")]
        public async Task<ActionResult<UserResponse>> GetMe()
        {
            try
            {
                return Ok(await _service.GetByIdAsync(_userId ?? Guid.Empty));
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [Authorize(Roles = Roles.Admin)]
        [HttpPost("{id}/reset-password")]
        public async Task<ActionResult> ResetPassword(Guid id)
        {
            try
            {
                await _service.ResetPasswordAsync(id);
                return Ok();
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [AllowAnonymous]
        [HttpPatch("reset-password")]
        public async Task<ActionResult> EditPassword([FromBody] ResetPasswordRequest request)
        {
            try
            {
                await _service.ResetPasswordAsync(request);
                return Ok();
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }


        [Authorize(Roles = Roles.Admin)]
        [HttpPatch("{id}/verify")]
        public async Task<ActionResult> VerifyUser(Guid id)
        {
            try
            {
                await _service.VerifyAsync(id);
                return Ok();
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [HttpPatch("{id}/deactivate")]
        public async Task<ActionResult> Deactivate(Guid id)
        {
            try
            {
                await _service.DeactivateAsync(id);
                return Ok();
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [Authorize(Roles = Roles.Client)]
        [HttpPatch("verify")]
        public async Task<ActionResult> Verify([FromQuery] string verificationKey)
        {
            try
            {
                await _service.VerifyAsync(verificationKey);
                return Ok();
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }
    }
}