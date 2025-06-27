namespace eTouristAgencyAPI.Services.Interfaces
{
    public interface IUserContextService
    {
        Guid? GetUserId();
        bool UserHasRole(string roleName);
        string GetUsername();
    }
}
