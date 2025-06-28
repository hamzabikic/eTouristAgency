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
        private readonly bool _isAdmin;
        private readonly Guid? _userId;

        public UserService(eTouristAgencyDbContext dbContext, IMapper mapper, IUserContextService userContextService) : base(dbContext, mapper)
        {
            _isAdmin = userContextService.UserHasRole(Roles.Admin);
            _userId = userContextService.GetUserId();
        }

        public override Task<UserResponse> GetByIdAsync(Guid id)
        {
            if (!_isAdmin && _userId != id) throw new UnauthorizedAccessException();

            return base.GetByIdAsync(id);
        }

        public override Task<UserResponse> UpdateAsync(Guid id, UpdateUserRequest updateModel)
        {
            if (!_isAdmin && _userId != id) throw new UnauthorizedAccessException();

            return base.UpdateAsync(id, updateModel);
        }

        public async Task<bool> ExistsAsync(string username, string password)
        {
            if (string.IsNullOrEmpty(username) && string.IsNullOrEmpty(password)) throw new Exception("You did not provide any parameter.");

            if (!string.IsNullOrEmpty(username) && await UsernameExistsAsync(username)) return true;
            if (!string.IsNullOrEmpty(password) && await EmailExistsAsync(password)) return true;

            return false;
        }

        private async Task<bool> UsernameExistsAsync(string username)
        {
            return await _dbContext.Users.AnyAsync(x => x.Username == username);
        }

        private async Task<bool> EmailExistsAsync(string email)
        {
            return await _dbContext.Users.AnyAsync(x => x.Email == email);
        }

        protected override async Task BeforeInsertAsync(AddUserRequest insertModel, User dbModel)
        {
            #region Request validation
            if (insertModel.Password != insertModel.ConfirmPassword) throw new Exception("Entered passwords are not equal.");
            if (await UsernameExistsAsync(insertModel.Username)) throw new Exception("Entered username is already in usage.");
            if (await EmailExistsAsync(insertModel.Email)) throw new Exception("Entered email is already in usage.");

            if (_isAdmin && !insertModel.RoleIds.Any())
            {
                throw new Exception("Role list is not provided.");
            }
            #endregion

            dbModel.Id = Guid.NewGuid();
            dbModel.IsActive = true;

            var passwordHasher = new PasswordHasher<User>();
            dbModel.PasswordHash = passwordHasher.HashPassword(dbModel, insertModel.Password);

            if (!_isAdmin)
            {
                var role = await _dbContext.Roles.FindAsync(AppConstants.FixedRoleClientId);
                dbModel.IsVerified = false;
                dbModel.Roles.Add(role);

                return;
            }

            foreach (var roleId in insertModel.RoleIds)
            {
                var role = await _dbContext.Roles.FindAsync(roleId);

                if (role == null)
                    throw new Exception($"Provided role id {roleId} is not valid.");

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
            if (await UsernameExistsAsync(updateModel.Username)) throw new Exception("Entered username is already in usage.");
            if (await EmailExistsAsync(updateModel.Email)) throw new Exception("Entered email is already in usage.");

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