using eTouristAgencyAPI.Services.Interfaces;
using Mapster;
using Microsoft.Extensions.DependencyInjection;

namespace eTouristAgencyAPI.Services.IoC
{
    public static class ServiceRegistration
    {
        public static IServiceCollection AddServices(this IServiceCollection services)
        {
            //Service registration
            services.AddTransient<IUserService, UserService>();

            //Mapster registration
            services.AddMapster();

            return services;
        }
    }
}
