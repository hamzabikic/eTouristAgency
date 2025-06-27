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
        public UserController(IUserService userService) : base(userService)
        {

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
    }
}