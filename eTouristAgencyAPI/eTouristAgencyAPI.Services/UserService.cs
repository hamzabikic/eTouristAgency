using eTouristAgencyAPI.Models.RequestModel;
using eTouristAgencyAPI.Models.ResponseModel;
using eTouristAgencyAPI.Models.SearchModels;
using eTouristAgencyAPI.Services.Database;
using eTouristAgencyAPI.Services.Database.Models;
using eTouristAgencyAPI.Services.Interfaces;
using MapsterMapper;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;

namespace eTouristAgencyAPI.Services
{
    public class UserService : CRUDService<User, UserResponse, UserSearchModel, AddUserRequest>, IUserService
    {
        public UserService(eTouristAgencyDbContext dbContext, IMapper mapper) : base(dbContext, mapper)
        { }

        protected override void BeforeInsert(AddUserRequest insertModel, User dbModel)
        {
            dbModel.Id = Guid.NewGuid();

            var passwordHasher = new PasswordHasher<User>();
            dbModel.PasswordHash = passwordHasher.HashPassword(dbModel, insertModel.Password);

            dbModel.IsActive = true;

            foreach (var roleId in insertModel.RoleIds)
            {
                var role = _dbContext.Roles.Find(roleId);

                if (role == null)
                    throw new Exception($"Provided role id {roleId} is not valid.");

                dbModel.Roles.Add(role);
            }
        }

        protected override IQueryable<User> BeforeFetchAllData(IQueryable<User> queryable)
        {
            queryable = queryable.Include(x => x.Roles);

            return queryable;
        }
    }
}