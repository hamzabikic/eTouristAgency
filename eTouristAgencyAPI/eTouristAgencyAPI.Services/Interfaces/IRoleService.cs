using eTouristAgencyAPI.Models.ResponseModels.Role;
using eTouristAgencyAPI.Models.SearchModels;
using eTouristAgencyAPI.Services.Database.Models;

namespace eTouristAgencyAPI.Services.Interfaces
{
    public interface IRoleService : IBaseService<Role, RoleResponse, RoleSearchModel>
    {
    }
}
