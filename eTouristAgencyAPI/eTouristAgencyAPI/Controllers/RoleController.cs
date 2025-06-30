using eTouristAgencyAPI.Models.ResponseModels.Role;
using eTouristAgencyAPI.Models.SearchModels;
using eTouristAgencyAPI.Services.Constants;
using eTouristAgencyAPI.Services.Database.Models;
using eTouristAgencyAPI.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;

namespace eTouristAgencyAPI.Controllers
{
    [Authorize(Roles = Roles.Admin)]
    public class RoleController : BaseController<Role, RoleResponse, RoleSearchModel>
    {
        public RoleController(IRoleService roleService) : base(roleService)
        {

        }
    }
}