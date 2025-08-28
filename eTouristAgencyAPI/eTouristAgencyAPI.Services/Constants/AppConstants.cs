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

        public static readonly Guid FixedOfferStatusDraft = new Guid("57C12C77-C593-424D-A481-40BECB061B3A");
        public static readonly Guid FixedOfferStatusActive = new Guid("1126543D-D3CC-4278-A919-68D82D761F95");
        public static readonly Guid FixedOfferStatusInactive = new Guid("2785E992-531B-40BD-8311-62541AD85B88");
        public static readonly Guid FixedOfferDiscountTypeFirstMinute = new Guid("974801DD-FD63-4AA6-AF62-7C62186F5DB1");
        public static readonly Guid FixedOfferDiscountTypeLastMinute = new Guid("D7913839-E8D7-4B66-AA66-38E7BF1F86E1");
        public static readonly Guid FixedReservationStatusNotPaid = new Guid("C55BC19B-7276-416C-8BB1-B7CD78245AC0");
        public static readonly Guid FixedReservationStatusCancelled = new Guid("962A3C05-FA18-4183-B0FE-84A3E88FD4AA");
        public static readonly Guid FixedReservationStatusLatePayment = new Guid("F6159BF6-5061-4583-8714-B40BD0A24476");

        public static readonly List<Guid> ForbiddenReservationStatusForReservationUpdate = new List<Guid> { FixedReservationStatusCancelled, FixedReservationStatusLatePayment };

        public static readonly List<Guid> AllowedEntityCodesToUpdate = new List<Guid>
        {
            EntityCodes.BoardType,
            EntityCodes.ReservationStatus
        };
    }
}
