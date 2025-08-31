using EasyNetQ;
using eTouristAgencyAPI.Notifications;
using eTouristAgencyAPI.Services;
using eTouristAgencyAPI.Services.Configuration;
using eTouristAgencyAPI.Services.Interfaces;
using eTouristAgencyAPI.Services.Messaging.RabbitMQ;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Newtonsoft.Json;

string rabbitMqHost = "";
string rabbitMqUsername = "";
string rabbitMqPassword = "";

var host = Host.CreateDefaultBuilder(args)
    .ConfigureAppConfiguration((context, config) =>
    {
        config.AddJsonFile("appsettings.json", optional: false, reloadOnChange: true);
    })
    .ConfigureServices((context, services) =>
    {
        services.Configure<SmtpConfig>(context.Configuration.GetSection("SmtpConfig"));
        services.Configure<FirebaseConfig>(context.Configuration.GetSection("FirebaseConfig"));

        services.AddTransient<ISmtpService, SmtpService>();
        services.AddTransient<IEmailNotificationService, EmailNotificationService>();
        services.AddTransient<IFirebaseNotificationService, FirebaseNotificationService>();

        rabbitMqHost = context.Configuration["RabbitMQConfig:Host"];
        rabbitMqUsername = context.Configuration["RabbitMQConfig:Username"];
        rabbitMqPassword = context.Configuration["RabbitMQConfig:Password"];
    })
    .Build();

var emailNotificationService = host.Services.GetRequiredService<IEmailNotificationService>();
var firebaseNotificationService = host.Services.GetRequiredService<IFirebaseNotificationService>();

IBus bus = null;
var maxRetries = 10;
for (int i = 0; i < maxRetries; i++)
{
    try
    {
        bus = RabbitHutch.CreateBus($"host={rabbitMqHost};username={rabbitMqUsername};password={rabbitMqPassword}");
        break;
    }
    catch (Exception ex)
    {
        if (i == maxRetries - 1) throw;
        await Task.Delay(5000);
    }
}

bus.PubSub.Subscribe<string>("Notification", async msg =>
{
    try
    {
        var rabbitMQNotification = JsonConvert.DeserializeObject<RabbitMQNotification>(msg);

        if (rabbitMQNotification.EmailNotification != null)
        {
            var emailNotification = rabbitMQNotification.EmailNotification;

            foreach (var recipient in emailNotification.Recipients)
            {
                try
                {
                    await emailNotificationService.SendEmailNotificationAsync(emailNotification.Title, emailNotification.Html, emailNotification.AdditionalImage, recipient);
                    await CustomLogger.LogInfo($"Succesfully sent email notification with title '{emailNotification.Title}' to: {recipient}");
                }
                catch (Exception ex)
                {
                    await CustomLogger.LogError($"Error while sending email notification with title '{emailNotification.Title}' to: {recipient} - {ex.Message}");
                }
            }
        }

        if (rabbitMQNotification.FirebaseNotification != null)
        {
            var firebaseNotification = rabbitMQNotification.FirebaseNotification;

            foreach (var firebaseToken in firebaseNotification.FirebaseTokens)
            {
                try
                {
                    await firebaseNotificationService.SendNotificationAsync(firebaseToken, firebaseNotification.Title, firebaseNotification.Text, firebaseNotification.Data);
                    await CustomLogger.LogInfo($"Succesfully sent firebase notification with title '{firebaseNotification.Title}' to: {firebaseToken}");
                }
                catch (Exception ex)
                {
                    await CustomLogger.LogError($"Error while sending firebase notification with title '{firebaseNotification.Title}' to: {firebaseToken} - {ex.Message}");
                }
            }
        }
    }
    catch (Exception ex)
    {
        await CustomLogger.LogError($"Error while sending notifications: {ex.Message}");
    }
});

Console.ReadLine();