using eTouristAgencyAPI.Services.Configuration;
using eTouristAgencyAPI.Services.Interfaces;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace eTouristAgencyAPI.Services.IoC
{
    public static class DependencyInjection
    {
        public static IServiceCollection AddServices(this IServiceCollection services)
        {
            //Service registration
            services.AddTransient<IUserContextService, UserContextService>();
            services.AddTransient<IUserService, UserService>();
            services.AddTransient<IRoleService, RoleService>();
            services.AddTransient<ISmtpService, SmtpService>();
            services.AddTransient<IVerificationCodeService, VerificationCodeService>();
            services.AddTransient<ICountryService, CountryService>();
            services.AddTransient<ICityService, CityService>();
            services.AddTransient<IHotelImageService, HotelImageService>();
            services.AddTransient<IHotelService, HotelService>();
            services.AddTransient<IOfferDiscountService, OfferDiscountService>();
            services.AddTransient<IRoomService, RoomService>();
            services.AddTransient<IOfferWriteService, OfferWriteService>();
            services.AddTransient<BaseOfferStatusService>();
            services.AddTransient<InitialOfferStatusService>();
            services.AddTransient<DraftOfferStatusService>();
            services.AddTransient<ActiveOfferStatusService>();
            services.AddTransient<InactiveOfferStatusService>();
            services.AddTransient<IOfferService, OfferService>();
            services.AddTransient<IEntityCodeValueService, EntityCodeValueService>();
            services.AddTransient<IRoomTypeService, RoomTypeService>();

            return services;
        }

        public static IServiceCollection AddConfiguration(this IServiceCollection services, IConfiguration configuration)
        {
            services.Configure<SmtpConfig>(configuration.GetSection("SmtpConfig"));

            return services;
        }
    }
}