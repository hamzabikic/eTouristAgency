using eTouristAgencyAPI.Models.ResponseModels.Role;
using eTouristAgencyAPI.Models.SearchModels;
using eTouristAgencyAPI.Services.Database;
using eTouristAgencyAPI.Services.Database.Models;
using eTouristAgencyAPI.Services.Interfaces;
using MapsterMapper;

namespace eTouristAgencyAPI.Services
{
    public class RoleService : BaseService<Role, RoleResponse, RoleSearchModel>, IRoleService
    {
        public RoleService(eTouristAgencyDbContext dbContext, IMapper mapper) : base(dbContext, mapper) { }
    }
}