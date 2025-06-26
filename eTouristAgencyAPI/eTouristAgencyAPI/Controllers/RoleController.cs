using eTouristAgencyAPI.Models.ResponseModels.Role;
using eTouristAgencyAPI.Models.SearchModels;
using eTouristAgencyAPI.Services.Database.Models;
using eTouristAgencyAPI.Services.Interfaces;

namespace eTouristAgencyAPI.Controllers
{
    public class RoleController : BaseController<Role, RoleResponse, RoleSearchModel>
    {
        public RoleController(IRoleService roleService) : base(roleService)
        {

        }
    }
}