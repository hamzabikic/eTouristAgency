using System.Net.Mail;
using System.Net.Mime;
using System.Reflection;
using eTouristAgencyAPI.Services.Interfaces;

namespace eTouristAgencyAPI.Services
{
    public class EmailNotificationService : IEmailNotificationService
    {
        private readonly ISmtpService _smtpService;
        private readonly string PATH_TO_DIRECTORY = "eTouristAgencyAPI.Services.EmailTemplates";

        public EmailNotificationService(ISmtpService smtpService)
        {
            _smtpService = smtpService;
        }

        public async Task SendEmailNotificationAsync(string title, string text, byte[]? additionalImage, params string[] recepients)
        {
            var assembly = Assembly.GetExecutingAssembly();
            var htmlResourceName = $"{PATH_TO_DIRECTORY}.emailNotification.html";

            using var htmlStream = assembly.GetManifestResourceStream(htmlResourceName);
            using var htmlReader = new StreamReader(htmlStream);
            string html = await htmlReader.ReadToEndAsync();

            html = html.Replace("***title***", title);
            html = html.Replace("***text***", text);

            var logoResourceName = $"{PATH_TO_DIRECTORY}.Images.logo.png";
            using var logoStream = assembly.GetManifestResourceStream(logoResourceName);
            using var tempFile = new MemoryStream();
            await logoStream.CopyToAsync(tempFile);
            tempFile.Position = 0;

            var htmlView = AlternateView.CreateAlternateViewFromString(html, null, MediaTypeNames.Text.Html);
            var logoResource = new LinkedResource(tempFile, MediaTypeNames.Image.Png)
            {
                ContentId = "logo",
                TransferEncoding = TransferEncoding.Base64
            };
            htmlView.LinkedResources.Add(logoResource);

            if (additionalImage != null)
            {
                MemoryStream additionalImageStream = new MemoryStream(additionalImage);
                additionalImageStream.Position = 0;

                var additionalImageResource = new LinkedResource(additionalImageStream, "application/octet-stream")
                {
                    ContentId = "additionalImage",
                    TransferEncoding = TransferEncoding.Base64
                };
                htmlView.LinkedResources.Add(additionalImageResource);
            }

            await _smtpService.SendAsync(title, htmlView, recepients);
        }
    }
}