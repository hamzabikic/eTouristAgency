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
        public override Task<ActionResult<PaginatedList<UserResponse>>> GetAll([FromQuery] UserSearchModel searchModel)
        {
            return base.GetAll(searchModel);
        }

        [AllowAnonymous]
        [HttpGet("Exists")]
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

        [HttpGet("Me")]
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
    }
}