using eTouristAgencyAPI.Models.RequestModels.UserFirebaseToken;

namespace eTouristAgencyAPI.Services.Interfaces
{
    public interface IUserFirebaseTokenService
    {
        Task AddAsync(AddUserFirebaseTokenRequest request);
        Task UpdateAsync(UpdateUserFirebaseTokenRequest request);
        Task RemoveAllTokensExceptAsync(string firebaseTokenToIgnore, Guid userId);
        Task DeleteAsync(string firebaseToken);
    }
}
