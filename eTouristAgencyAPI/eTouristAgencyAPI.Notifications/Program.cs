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
        config.AddEnvironmentVariables();
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
for (int i = 0; i < 5; i++)
{
    try
    {
        bus = RabbitHutch.CreateBus($"host={rabbitMqHost};username={rabbitMqUsername};password={rabbitMqPassword};timeout=30");
        Console.WriteLine("Connected to RabbitMQ successfully.");
        break;
    }
    catch (Exception ex)
    {
        Console.WriteLine($"Connection attempt {i + 1}/5 failed: {ex.Message}");

        if (i == 4)
        {
            Console.WriteLine("Failed to connect to RabbitMQ. Exiting - Docker will restart.");
            Environment.Exit(1);
        }

        await Task.Delay(2000);
    }
}

try
{
    await bus.PubSub.SubscribeAsync<string>("Notification", async msg =>
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
                        await emailNotificationService.SendEmailNotificationAsync(
                            emailNotification.Title,
                            emailNotification.Html,
                            emailNotification.AdditionalImage,
                            recipient);

                        await CustomLogger.LogInfo($"Successfully sent email '{emailNotification.Title}' to: {recipient}");
                    }
                    catch (Exception ex)
                    {
                        await CustomLogger.LogError($"Email send failed '{emailNotification.Title}' to: {recipient} - {ex.Message}");
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
                        await firebaseNotificationService.SendNotificationAsync(
                            firebaseToken,
                            firebaseNotification.Title,
                            firebaseNotification.Text,
                            firebaseNotification.Data);

                        await CustomLogger.LogInfo($"Successfully sent Firebase '{firebaseNotification.Title}' to: {firebaseToken}");
                    }
                    catch (Exception ex)
                    {
                        await CustomLogger.LogError($"Firebase send failed '{firebaseNotification.Title}' to: {firebaseToken} - {ex.Message}");
                    }
                }
            }
        }
        catch (Exception ex)
        {
            await CustomLogger.LogError($"Message processing failed: {ex.Message}");
        }
    });

    Console.WriteLine("Subscribed to RabbitMQ successfully. Service running...");
}
catch (Exception ex)
{
    Console.WriteLine($"Subscription failed: {ex.Message}");
    Console.WriteLine("Exiting - Docker will restart the container.");
    Environment.Exit(1);
}

await Task.Delay(Timeout.Infinite);