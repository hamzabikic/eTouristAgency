namespace eTouristAgencyAPI.Services.Interfaces
{
    public interface IEmailNotificationService
    {
        Task SendEmailNotificationAsync(string title, string text, byte[]? additionalImage, params string[] recepients);
    }
}
