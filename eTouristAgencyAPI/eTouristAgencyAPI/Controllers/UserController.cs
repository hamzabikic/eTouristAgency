using eTouristAgencyAPI.Models.RequestModel;
using eTouristAgencyAPI.Models.ResponseModel;
using eTouristAgencyAPI.Models.SearchModels;
using eTouristAgencyAPI.Services.Database.Models;
using eTouristAgencyAPI.Services.Interfaces;

namespace eTouristAgencyAPI.Controllers
{
    public class UserController : CRUDController<User, UserResponse, UserSearchModel, AddUserRequest>
    {
        public UserController(IUserService userService) : base(userService)
        {

        }
    }
}