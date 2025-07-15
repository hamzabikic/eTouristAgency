using eTouristAgencyAPI.Services.Database.Models;
using eTouristAgencyAPI.Services.Enums;

namespace eTouristAgencyAPI.Services.Constants
{
    public static class AppConstants
    {
        public static readonly Guid FixedRoleClientId = new Guid("F193F30A-7406-4E10-B226-DDE0EE5F5E57");
        public static readonly Guid FixedRoleAdminId = new Guid("ECC8E410-5E61-493E-A99E-51ADE8E1AA1D");
        public static readonly Guid FixedEmailVerificationTypeForEmailVerification = new Guid("F20D5A32-E3AF-4B29-9431-6BB1A9726B79");
        public static readonly Guid FixedEmailVerificationTypeForResetPassword = new Guid("114EF7B1-2D3C-402A-BB74-9C49CDFD3D42");

        public static readonly Dictionary<EmailVerificationType, Guid> EmailVerificationTypes = new Dictionary<EmailVerificationType, Guid>
        {
            {EmailVerificationType.EmailVerification,FixedEmailVerificationTypeForEmailVerification},
            {EmailVerificationType.ResetPassword,FixedEmailVerificationTypeForResetPassword}
        };
    }
}
