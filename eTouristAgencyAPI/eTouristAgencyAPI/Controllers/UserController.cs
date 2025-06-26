using eTouristAgencyAPI.Models.RequestModels.User;
using eTouristAgencyAPI.Models.ResponseModels.User;
using eTouristAgencyAPI.Models.SearchModels;
using eTouristAgencyAPI.Services.Database.Models;
using eTouristAgencyAPI.Services.Interfaces;

namespace eTouristAgencyAPI.Controllers
{
    public class UserController : CRUDController<User, UserResponse, UserSearchModel, AddUserRequest, UpdateUserRequest>
    {
        public UserController(IUserService userService) : base(userService)
        {

        }
    }
}