namespace eTouristAgencyAPI.Services.Interfaces
{
    public interface ISmtpService
    {
        Task SendAsync(string subject, string body, params string[] recepients);
    }
}
