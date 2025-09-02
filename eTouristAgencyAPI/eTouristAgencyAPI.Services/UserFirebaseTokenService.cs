using eTouristAgencyAPI.Models.RequestModels.UserFirebaseToken;
using eTouristAgencyAPI.Services.Constants;
using eTouristAgencyAPI.Services.Database;
using eTouristAgencyAPI.Services.Database.Models;
using eTouristAgencyAPI.Services.Interfaces;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;

namespace eTouristAgencyAPI.Services
{
    public class UserFirebaseTokenService : IUserFirebaseTokenService
    {
        private readonly eTouristAgencyDbContext _dbContext;
        private readonly IMapper _mapper;
        private readonly IUserContextService _userContextService;
        private readonly Guid? _userId;

        public UserFirebaseTokenService(eTouristAgencyDbContext dbContext, IMapper mapper, IUserContextService userContextService)
        {
            _dbContext = dbContext;
            _mapper = mapper;
            _userContextService = userContextService;
            _userId = userContextService.GetUserId();
        }

        public async Task AddAsync(AddUserFirebaseTokenRequest request)
        {
            var userFirebaseToken = await _dbContext.UserFirebaseTokens.FirstOrDefaultAsync(x => x.FirebaseToken == request.FirebaseToken && x.UserId == _userId);

            if (userFirebaseToken != null)
            {
                userFirebaseToken.ModifiedOn = DateTime.Now;
                await _dbContext.SaveChangesAsync();

                return;
            }

            userFirebaseToken = _mapper.Map<AddUserFirebaseTokenRequest, UserFirebaseToken>(request);
            userFirebaseToken.Id = Guid.NewGuid();
            userFirebaseToken.UserId = _userId ?? Guid.Empty;

            await _dbContext.UserFirebaseTokens.AddAsync(userFirebaseToken);
            await _dbContext.SaveChangesAsync();

            await RemoveAllTokensModifiedBeforeLastYearAsync();
        }

        public async Task UpdateAsync(UpdateUserFirebaseTokenRequest request)
        {
            var userFirebaseToken = await _dbContext.UserFirebaseTokens.FirstOrDefaultAsync(x => x.FirebaseToken == request.OldFirebaseToken && x.UserId == _userId);

            if (userFirebaseToken == null) throw new Exception("Firebase token provided as OldFirebaseToken is not found in the database.");

            userFirebaseToken.FirebaseToken = request.NewFirebaseToken;
            userFirebaseToken.ModifiedOn = DateTime.Now;

            await _dbContext.SaveChangesAsync();

            await RemoveAllTokensModifiedBeforeLastYearAsync();
        }

        public async Task DeleteAsync(string firebaseToken)
        {
            var userFirebaseToken = await _dbContext.UserFirebaseTokens.FirstOrDefaultAsync(x=> x.UserId == _userId && x.FirebaseToken == firebaseToken);

            if (userFirebaseToken == null) throw new Exception("Provided firebase token is not found in the database.");

            _dbContext.UserFirebaseTokens.Remove(userFirebaseToken);
            await _dbContext.SaveChangesAsync();
        }

        public async Task RemoveAllTokensExceptAsync(string firebaseTokenToIgnore, Guid userId)
        {
            var firebaseTokensToDelete = await _dbContext.UserFirebaseTokens.Where(x => x.UserId == userId && (firebaseTokenToIgnore == null || x.FirebaseToken != firebaseTokenToIgnore)).ToListAsync();

            _dbContext.RemoveRange(firebaseTokensToDelete);
            await _dbContext.SaveChangesAsync();
        }

        private async Task RemoveAllTokensModifiedBeforeLastYearAsync()
        {
            var tokensToRemove = await _dbContext.UserFirebaseTokens.Where(x => x.ModifiedOn < DateTime.Now.AddYears(-1)).ToListAsync();

            _dbContext.UserFirebaseTokens.RemoveRange(tokensToRemove);
            await _dbContext.SaveChangesAsync();
        }
    }
}
