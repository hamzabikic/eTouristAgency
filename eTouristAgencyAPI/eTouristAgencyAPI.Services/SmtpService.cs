using System.Net;
using System.Net.Mail;
using eTouristAgencyAPI.Services.Configuration;
using eTouristAgencyAPI.Services.Interfaces;
using Microsoft.Extensions.Options;

namespace eTouristAgencyAPI.Services
{
    public class SmtpService : ISmtpService
    {
        private readonly SmtpConfig _smtpConfig;

        public SmtpService(IOptions<SmtpConfig> smtpConfig)
        {
            _smtpConfig = smtpConfig.Value;
        }

        public async Task SendAsync(string subject, AlternateView body, params string[] recepients)
        {
            var smtpClient = new SmtpClient(_smtpConfig.Host)
            {
                Port = _smtpConfig.Port,
                Credentials = new NetworkCredential(_smtpConfig.Username, _smtpConfig.Password),
                EnableSsl = _smtpConfig.EnableSsl
            };

            var mailMessage = new MailMessage();
            mailMessage.From = new MailAddress("eTouristAgency@gmail.com", "eTouristAgency");
            mailMessage.Subject = subject;
            mailMessage.IsBodyHtml = true;
            mailMessage.AlternateViews.Add(body);

            foreach (var recepient in recepients)
            {
                mailMessage.To.Add(new MailAddress(recepient));
            }

            try
            {
                await smtpClient.SendMailAsync(mailMessage);
            }catch(Exception ex)
            {

            }
        }
    }
}