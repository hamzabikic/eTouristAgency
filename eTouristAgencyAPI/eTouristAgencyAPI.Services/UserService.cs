using EasyNetQ;
using eTouristAgencyAPI.Models.RequestModels.User;
using eTouristAgencyAPI.Models.ResponseModels.User;
using eTouristAgencyAPI.Models.SearchModels;
using eTouristAgencyAPI.Services.Constants;
using eTouristAgencyAPI.Services.Database;
using eTouristAgencyAPI.Services.Database.Models;
using eTouristAgencyAPI.Services.Enums;
using eTouristAgencyAPI.Services.Helpers;
using eTouristAgencyAPI.Services.Interfaces;
using eTouristAgencyAPI.Services.Messaging.RabbitMQ;
using MapsterMapper;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Newtonsoft.Json;

namespace eTouristAgencyAPI.Services
{
    public class UserService : CRUDService<User, UserResponse, UserSearchModel, AddUserRequest, UpdateUserRequest>, IUserService
    {
        private readonly IVerificationCodeService _verificationCodeService;
        private readonly IEmailContentService _emailContentService;
        private readonly IBus _bus;

        private readonly bool _isAdmin;
        private readonly Guid? _userId;

        public UserService(eTouristAgencyDbContext dbContext,
                           IMapper mapper,
                           IUserContextService userContextService,
                           IVerificationCodeService verificationCodeService,
                           IEmailContentService emailContentService,
                           IBus bus) : base(dbContext, mapper)
        {
            _verificationCodeService = verificationCodeService;
            _emailContentService = emailContentService;

            _isAdmin = userContextService.UserHasRole(Roles.Admin);
            _userId = userContextService.GetUserId();
            _bus = bus;
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

        public async Task<bool> ExistsAsync(string username, string email)
        {
            if (string.IsNullOrEmpty(username) && string.IsNullOrEmpty(email)) throw new Exception("You did not provide any parameter.");

            if (!string.IsNullOrEmpty(username) && await UsernameExistsAsync(username)) return true;
            if (!string.IsNullOrEmpty(email) && await EmailExistsAsync(email)) return true;

            return false;
        }

        public async Task ResetPasswordAsync(Guid userId)
        {
            var user = await _dbContext.Users.Include(x => x.Roles).FirstOrDefaultAsync(x => x.Id == userId && x.IsActive);

            if (user == null) throw new Exception("User with provided id is not found.");
            if (!user.Roles.Any(x => x.Id == AppConstants.FixedRoleClientId)) throw new Exception("Reset password is only allowed for client users.");

            var generatedPassword = PasswordGenerator.GeneratePassword();
            var passwordHasher = new PasswordHasher<User>();
            user.PasswordHash = passwordHasher.HashPassword(user, generatedPassword);
            await _dbContext.SaveChangesAsync();

            var emailTitle = await _emailContentService.GetGeneratedPasswordTitleAsync();
            var emailText = await _emailContentService.GetGeneratedPasswordTextAsync(generatedPassword);
            var emailNotification = new RabbitMQEmailNotification
            {
                Title = emailTitle,
                Html = emailText,
                Recipients = [user.Email]
            };

            _bus.PubSub.Publish(JsonConvert.SerializeObject(new RabbitMQNotification
            {
                EmailNotification = emailNotification
            }));
        }

        public async Task ResetPasswordAsync(ResetPasswordRequest request)
        {
            var user = await _dbContext.Users.FirstOrDefaultAsync(x => x.Email == request.Email && x.IsActive);

            if (user == null) throw new Exception("User with provided email is not found.");

            await _verificationCodeService.DeactivateVerificationCodeAsync(request.VerificationKey, user.Id, EmailVerificationType.ResetPassword);

            var passwordHasher = new PasswordHasher<User>();
            user.PasswordHash = passwordHasher.HashPassword(user, request.Password);

            await _dbContext.SaveChangesAsync();
        }

        public async Task VerifyAsync(Guid userId)
        {
            var user = await _dbContext.Users.Include(x => x.Roles).FirstOrDefaultAsync(x => x.Id == userId);

            if (user == null) throw new Exception("User with provided id is not found.");
            if (!user.Roles.Any(x => x.Id == AppConstants.FixedRoleClientId)) throw new Exception("Verification is only allowed for client users.");

            user.IsVerified = true;
            await _dbContext.SaveChangesAsync();
        }

        public async Task VerifyAsync(string verificationKey)
        {
            await _verificationCodeService.DeactivateVerificationCodeAsync(verificationKey, _userId ?? Guid.Empty, EmailVerificationType.EmailVerification);

            var user = await _dbContext.Users.FindAsync(_userId);
            user.IsVerified = true;

            await _dbContext.SaveChangesAsync();
        }

        public async Task DeactivateAsync(Guid userId)
        {
            var user = await _dbContext.Users.Include(x => x.Roles).FirstOrDefaultAsync(x => x.Id == userId);

            if (user == null) throw new Exception("User with provided id is not found.");
            if (_isAdmin && !user.Roles.Any(x => x.Id == AppConstants.FixedRoleAdminId)) throw new Exception("Deactivation is only allowed for admin users.");
            if (!_isAdmin && userId != _userId) throw new Exception("This method is only allowed for your account.");

            user.IsActive = false;
            await _dbContext.SaveChangesAsync();
        }

        public async Task UpdateFirebaseTokenAsync(UpdateFirebaseTokenRequest request)
        {
            var user = await _dbContext.Users.FindAsync(_userId ?? Guid.Empty);

            user.FirebaseToken = request.FirebaseToken;

            await _dbContext.SaveChangesAsync();
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

            if (dbModel.Roles.Any(x => x.Name == Roles.Admin))
            {
                dbModel.IsVerified = true;
            }
        }

        protected override async Task<IQueryable<User>> BeforeFetchAllDataAsync(IQueryable<User> queryable, UserSearchModel searchModel)
        {
            queryable = queryable.Include(x => x.Roles);

            queryable = queryable.Where(x => x.IsActive);

            if (!string.IsNullOrEmpty(searchModel.SearchText))
            {
                queryable = queryable.Where(x => x.Username.ToLower().Contains(searchModel.SearchText.ToLower()) ||
                                                 x.Email.ToLower().Contains(searchModel.SearchText.ToLower()) ||
                                                 (x.FirstName + "" + x.LastName).ToLower().Contains(searchModel.SearchText.ToLower()));
            }

            if (searchModel.RoleId != null)
            {
                queryable = queryable.Where(x => x.Roles.Any(y => y.Id == searchModel.RoleId));
            }

            queryable = queryable.OrderByDescending(x => x.CreatedOn);

            return queryable;
        }

        protected override async Task BeforeUpdateAsync(UpdateUserRequest updateModel, User dbModel)
        {
            if (_userId != dbModel.Id && !dbModel.Roles.Any(x => x.Id == AppConstants.FixedRoleAdminId)) throw new Exception("Only users with the Admin role can be updated.");
            if (updateModel.Password != updateModel.ConfirmPassword) throw new Exception("Entered passwords are not equal.");
            if (_userId != dbModel.Id && (string.IsNullOrEmpty(updateModel.Password) || string.IsNullOrEmpty(updateModel.ConfirmPassword))) throw new Exception("You have to provide a new password.");
            if (updateModel.Username != dbModel.Username && await UsernameExistsAsync(updateModel.Username)) throw new Exception("Entered username is already in usage.");
            if (updateModel.Email != dbModel.Email)
            {
                if (await EmailExistsAsync(updateModel.Email)) throw new Exception("Entered email is already in usage.");

                if (dbModel.Roles.Any(x => x.Name == Roles.Client)) dbModel.IsVerified = false;
            }

            if (_userId == dbModel.Id)
            {
                var passwordHasher = new PasswordHasher<User>();
                dbModel.PasswordHash = passwordHasher.HashPassword(dbModel, updateModel.Password);
            }

            dbModel.ModifiedOn = DateTime.Now;
        }

        protected override Task<IQueryable<User>> BeforeFetchRecordAsync(IQueryable<User> queryable)
        {
            return Task.FromResult<IQueryable<User>>(queryable.Include(x => x.Roles));
        }
    }
}