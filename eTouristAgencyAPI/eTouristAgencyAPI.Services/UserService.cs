using eTouristAgencyAPI.Models.RequestModels.User;
using eTouristAgencyAPI.Models.ResponseModels.User;
using eTouristAgencyAPI.Models.SearchModels;
using eTouristAgencyAPI.Services.Constants;
using eTouristAgencyAPI.Services.Database;
using eTouristAgencyAPI.Services.Database.Models;
using eTouristAgencyAPI.Services.Interfaces;
using MapsterMapper;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;

namespace eTouristAgencyAPI.Services
{
    public class UserService : CRUDService<User, UserResponse, UserSearchModel, AddUserRequest, UpdateUserRequest>, IUserService
    {
        private readonly IUserContextService _userContextService;

        public UserService(eTouristAgencyDbContext dbContext, IMapper mapper, IUserContextService userContextService) : base(dbContext, mapper)
        {
            _userContextService = userContextService;
        }

        public override Task<UserResponse> GetByIdAsync(Guid id)
        {
            if (!_userContextService.UserHasRole(Roles.Admin))
            {
                if (_userContextService.GetUserId() != id) throw new UnauthorizedAccessException();
            }

            return base.GetByIdAsync(id);
        }

        public override Task<UserResponse> UpdateAsync(Guid id, UpdateUserRequest updateModel)
        {
            if (!_userContextService.UserHasRole(Roles.Admin))
            {
                if (_userContextService.GetUserId() != id) throw new UnauthorizedAccessException();
            }

            return base.UpdateAsync(id, updateModel);
        }

        protected override async Task BeforeInsertAsync(AddUserRequest insertModel, User dbModel)
        {
            if (insertModel.Password != insertModel.ConfirmPassword) throw new Exception("Entered passwords are not equal.");
            if (await _dbContext.Users.AnyAsync(x => x.Username == insertModel.Username)) throw new Exception("Entered username is already in usage.");
            if (await _dbContext.Users.AnyAsync(x => x.Email == insertModel.Email)) throw new Exception("Entered email is already in usage.");

            dbModel.Id = Guid.NewGuid();
            dbModel.IsActive = true;

            var passwordHasher = new PasswordHasher<User>();
            dbModel.PasswordHash = passwordHasher.HashPassword(dbModel, insertModel.Password);

            if (!_userContextService.UserHasRole(Roles.Admin))
            {
                var role = await _dbContext.Roles.FindAsync(AppConstants.FixedRoleClientId);
                dbModel.IsVerified = false;
                dbModel.Roles.Add(role);

                return;
            }

            if (!insertModel.RoleIds.Any())
            {
                throw new Exception("Role list is not provided.");
            }

            foreach (var roleId in insertModel.RoleIds)
            {
                var role = _dbContext.Roles.Find(roleId);

                if (role == null)
                    throw new Exception($"Provided role id {roleId} is not valid.");

                if (role.Id == AppConstants.FixedRoleAdminId) dbModel.IsVerified = true;

                dbModel.Roles.Add(role);
            }
        }

        protected override async Task<IQueryable<User>> BeforeFetchAllDataAsync(IQueryable<User> queryable, UserSearchModel searchModel)
        {
            queryable = queryable.Include(x => x.Roles);

            if (!string.IsNullOrEmpty(searchModel.SearchText))
            {
                queryable = queryable.Where(x => x.Username.ToLower().Contains(searchModel.SearchText.ToLower()) ||
                                                 x.Email.ToLower().Contains(searchModel.SearchText.ToLower()) ||
                                                 (x.FirstName + "" + x.LastName).ToLower().Contains(searchModel.SearchText.ToLower()));
            }

            return queryable;
        }

        protected override async Task BeforeUpdateAsync(UpdateUserRequest updateModel, User dbModel)
        {
            if (updateModel.Password != updateModel.ConfirmPassword) throw new Exception("Entered passwords are not equal.");

            var passwordHasher = new PasswordHasher<User>();
            dbModel.PasswordHash = passwordHasher.HashPassword(dbModel, updateModel.Password);
            dbModel.ModifiedOn = DateTime.Now;
        }

        protected override Task<IQueryable<User>> BeforeFetchRecordAsync(IQueryable<User> queryable)
        {
            return Task.FromResult<IQueryable<User>>(queryable.Include(x => x.Roles));
        }
    }
}