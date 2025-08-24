using eTouristAgencyAPI.Services.Database.Models;

namespace eTouristAgencyAPI.Services.Interfaces
{
    public interface IOfferContentBasedService
    {
        Task<List<User>> GetUsersForOfferAsync(Offer offer);
    }
}
