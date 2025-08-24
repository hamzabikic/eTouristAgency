using System.Diagnostics;
using EasyNetQ;
using eTouristAgencyAPI.Services.Constants;
using eTouristAgencyAPI.Services.Database;
using eTouristAgencyAPI.Services.Database.Models;
using eTouristAgencyAPI.Services.Enums;
using eTouristAgencyAPI.Services.Helpers;
using eTouristAgencyAPI.Services.Interfaces;
using eTouristAgencyAPI.Services.Messaging.RabbitMQ;
using Microsoft.EntityFrameworkCore;
using Newtonsoft.Json;

namespace eTouristAgencyAPI.Services
{
    public class VerificationCodeService : IVerificationCodeService
    {
        private readonly eTouristAgencyDbContext _dbContext;
        private readonly IEmailContentService _emailContentService;

        private readonly Guid? _userId;

        public VerificationCodeService(eTouristAgencyDbContext dbContext,
                                       IUserContextService userContextService,
                                       IEmailContentService emailContentService)
        {
            _dbContext = dbContext;
            _emailContentService = emailContentService;

            _userId = userContextService.GetUserId();
        }

        public async Task AddVerificationCodeAsync(EmailVerificationType verificationType, string email = "")
        {
            var user = await ValidateAndGetUserAsync(verificationType, email);

            var countOfRecordsLastDay = await _dbContext.EmailVerifications.CountAsync(x => x.UserId == user.Id &&
                                                                                            x.EmailVerificationTypeId == AppConstants.EmailVerificationTypes[verificationType] &&
                                                                                            x.ValidFrom > DateTime.Now.AddDays(-1));

            if (countOfRecordsLastDay > 4) throw new Exception("You can send verification code only 5 times in last 24 hours.");

            await DeactivateVerificationCodesAsync(verificationType, user.Id);

            var emailVerification = new EmailVerification
            {
                Id = Guid.NewGuid(),
                EmailVerificationTypeId = AppConstants.EmailVerificationTypes[verificationType],
                UserId = user.Id,
                ValidFrom = DateTime.Now,
                ValidTo = DateTime.Now.AddMinutes(2),
                VerificationKey = VerificationCodeGenerator.GenerateVerificationCode()
            };

            await _dbContext.AddAsync(emailVerification);
            await _dbContext.SaveChangesAsync();

            await SendVerificationCodeToEmailAsync(user, verificationType, emailVerification.VerificationKey, user.Email);
        }

        public async Task DeactivateVerificationCodeAsync(string verificationKey, Guid userId, EmailVerificationType verificationType)
        {
            var verificationCode = await _dbContext.EmailVerifications.FirstOrDefaultAsync(x => x.UserId == userId &&
                                                                                                x.VerificationKey == verificationKey &&
                                                                                                x.EmailVerificationTypeId == AppConstants.EmailVerificationTypes[verificationType] &&
                                                                                                x.ValidTo > DateTime.Now);

            if (verificationCode == null) throw new Exception("Verification code is not valid.");

            verificationCode.ValidTo = DateTime.Now;

            await _dbContext.SaveChangesAsync();
        }

        public async Task<bool> PasswordVerificationCodeExists(string verificationKey)
        {
            return await _dbContext.EmailVerifications.Include(x => x.User).AnyAsync(x => x.VerificationKey == verificationKey &&
                                                                                         x.ValidTo > DateTime.Now &&
                                                                                         x.EmailVerificationTypeId == AppConstants.FixedEmailVerificationTypeForResetPassword);
        }

        private async Task SendVerificationCodeToEmailAsync(User user, EmailVerificationType verificationType, string verificationKey, string email)
        {
            switch (verificationType)
            {
                case EmailVerificationType.EmailVerification:
                    var notificationTitle = await _emailContentService.GetEmailVerificationTitleAsync();
                    var notificationText = await _emailContentService.GetEmailVerificationTextAsync(user.FirstName, user.LastName, verificationKey);
                    var emailNotification = new RabbitMQEmailNotification
                    {
                        Title = notificationTitle,
                        Html = notificationText,
                        Recipients = [email]
                    };

                    var bus = RabbitHutch.CreateBus("host=localhost;username=admin;password=admin");
                    bus.PubSub.Publish(JsonConvert.SerializeObject(new RabbitMQNotification
                    {
                        EmailNotification = emailNotification
                    }));

                    break;
                case EmailVerificationType.ResetPassword:
                    notificationTitle = await _emailContentService.GetResetPasswordTitleAsync();
                    notificationText = await _emailContentService.GetResetPasswordTextAsync(user.FirstName, user.LastName, verificationKey);
                    emailNotification = new RabbitMQEmailNotification
                    {
                        Title = notificationTitle,
                        Html = notificationText,
                        Recipients = [email]
                    };

                    bus = RabbitHutch.CreateBus("host=localhost;username=admin;password=admin");
                    bus.PubSub.Publish(JsonConvert.SerializeObject(new RabbitMQNotification
                    {
                        EmailNotification = emailNotification
                    }));

                    break;
                default:
                    throw new Exception("Verification type is not valid.");
            }
        }

        private async Task<User> ValidateAndGetUserAsync(EmailVerificationType verificationType, string email = "")
        {
            User user;

            switch (verificationType)
            {
                case EmailVerificationType.EmailVerification:
                    user = await _dbContext.Users.FindAsync(_userId);

                    if (user.IsVerified) throw new Exception("Email is already verified.");

                    return user;
                case EmailVerificationType.ResetPassword:
                    user = await _dbContext.Users.FirstOrDefaultAsync(x => x.IsActive && x.Email == email);

                    if (user == null) throw new Exception("User with provided email is not found.");

                    return user;
                default:
                    throw new Exception("Invalid verification type.");
            }
        }

        private async Task DeactivateVerificationCodesAsync(EmailVerificationType verificationType, Guid userId)
        {
            var emailVerificationRecords = await _dbContext.EmailVerifications.Where(x => x.UserId == userId &&
                                                                                          x.EmailVerificationTypeId == AppConstants.EmailVerificationTypes[verificationType] &&
                                                                                          x.ValidTo > DateTime.Now).ToListAsync();

            foreach (var emailVerification in emailVerificationRecords)
            {
                emailVerification.ValidTo = DateTime.Now;
            }

            await _dbContext.SaveChangesAsync();
        }
    }
}