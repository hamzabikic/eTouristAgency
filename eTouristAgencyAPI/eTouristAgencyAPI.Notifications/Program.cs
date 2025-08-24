using EasyNetQ;
using eTouristAgencyAPI.Services;
using eTouristAgencyAPI.Services.Configuration;
using eTouristAgencyAPI.Services.Interfaces;
using eTouristAgencyAPI.Services.Messaging.RabbitMQ;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Newtonsoft.Json;

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
    })
    .Build();

var emailNotificationService = host.Services.GetRequiredService<IEmailNotificationService>();
var firebaseNotificationService = host.Services.GetRequiredService<IFirebaseNotificationService>();

var bus = RabbitHutch.CreateBus("host=localhost;username=admin;password=admin");

bus.PubSub.Subscribe<string>("Notification", async msg => {
    var rabbitMQNotification = JsonConvert.DeserializeObject<RabbitMQNotification>(msg);

    if (rabbitMQNotification.EmailNotification != null)
    {
        var emailNotification = rabbitMQNotification.EmailNotification;
        await emailNotificationService.SendEmailNotificationAsync(emailNotification.Title, emailNotification.Html, emailNotification.AdditionalImage, emailNotification.Recipients.ToArray());
    }

    if(rabbitMQNotification.FirebaseNotification != null)
    {
        var firebaseNotification = rabbitMQNotification.FirebaseNotification;
        foreach(var firebaseToken in firebaseNotification.FirebaseTokens)
        {
            await firebaseNotificationService.SendNotificationAsync(firebaseToken, firebaseNotification.Title, firebaseNotification.Text);
        }
    }
});

Console.ReadLine();