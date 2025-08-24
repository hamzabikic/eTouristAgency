using eTouristAgencyAPI.Models.RequestModels.User;
using eTouristAgencyAPI.Models.ResponseModels.User;
using eTouristAgencyAPI.Models.SearchModels;
using eTouristAgencyAPI.Services.Database.Models;

namespace eTouristAgencyAPI.Services.Interfaces
{
    public interface IUserService : ICRUDService<User, UserResponse, UserSearchModel, AddUserRequest, UpdateUserRequest>
    {
        Task<bool> ExistsAsync(string username, string password);
        Task ResetPasswordAsync(Guid userId);
        Task ResetPasswordAsync(ResetPasswordRequest request);
        Task VerifyAsync(Guid userId);
        Task VerifyAsync(string verificationKey);
        Task DeactivateAsync(Guid userId);
        Task UpdateFirebaseTokenAsync(UpdateFirebaseTokenRequest request);
    }
}