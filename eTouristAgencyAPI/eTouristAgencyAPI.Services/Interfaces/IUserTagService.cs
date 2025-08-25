namespace eTouristAgencyAPI.Services.Interfaces
{
    public interface IUserTagService
    {
        Task AddTagsByUserIdAsync(Guid offerId, Guid userId);
    }
}
