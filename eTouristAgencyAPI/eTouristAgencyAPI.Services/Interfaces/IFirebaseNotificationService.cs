namespace eTouristAgencyAPI.Services.Interfaces
{
    public interface IFirebaseNotificationService
    {
        Task SendNotificationAsync(string deviceToken, string title, string body);
    }
}
