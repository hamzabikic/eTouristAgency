using eTouristAgencyAPI.Services.Database.Models;

namespace eTouristAgencyAPI.Services.Interfaces
{
    public interface IEmailContentService
    {
        Task<string> GetReservationStatusChangeTitleAsync();
        Task<string> GetReservationStatusChangeTextAsync(Reservation reservation);
        Task<string> GetEmailVerificationTitleAsync();
        Task<string> GetEmailVerificationTextAsync(string firstName, string lastName, string verificationKey);
        Task<string> GetResetPasswordTitleAsync();
        Task<string> GetResetPasswordTextAsync(string firstName, string lastName, string verificationKey);
        Task<string> GetOfferRecommendationTitleAsync(Offer offer);
        Task<string> GetOfferRecommendationTextAsync(Offer offer);
    }
}
