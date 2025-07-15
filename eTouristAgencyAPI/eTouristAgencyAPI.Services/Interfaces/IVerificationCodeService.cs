using eTouristAgencyAPI.Services.Enums;

namespace eTouristAgencyAPI.Services.Interfaces
{
    public interface IVerificationCodeService
    {
        Task AddVerificationCodeAsync(EmailVerificationType verificationType, string email = "");
        Task DeactivateVerificationCodeAsync(string verificationKey, Guid userId, EmailVerificationType verificationType);
        Task<bool> PasswordVerificationCodeExists(string verificationKey);
    }
}