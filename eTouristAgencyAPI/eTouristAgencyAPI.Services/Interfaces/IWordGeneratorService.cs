using eTouristAgencyAPI.Services.Database.Models;

namespace eTouristAgencyAPI.Services.Interfaces
{
    public interface IWordGeneratorService
    {
        byte[] GetPassengerListDocument(Offer offer);
    }
}
