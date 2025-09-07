using System.Net.Mail;

namespace eTouristAgencyAPI.Services.Interfaces
{
    public interface ISmtpService
    {
        Task SendAsync(string subject, AlternateView body, params string[] recepients);
    }
}
