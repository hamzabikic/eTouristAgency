using eTouristAgencyAPI.Models.RequestModel;
using eTouristAgencyAPI.Models.ResponseModel;
using eTouristAgencyAPI.Models.SearchModels;
using eTouristAgencyAPI.Services.Database.Models;

namespace eTouristAgencyAPI.Services.Interfaces
{
    public interface IUserService : ICRUDService<User, UserResponse, UserSearchModel, AddUserRequest>
    {
    }
}