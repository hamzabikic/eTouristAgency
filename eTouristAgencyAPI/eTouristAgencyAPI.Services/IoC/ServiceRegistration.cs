using eTouristAgencyAPI.Services.Interfaces;
using Microsoft.Extensions.DependencyInjection;

namespace eTouristAgencyAPI.Services.IoC
{
    public static class ServiceRegistration
    {
        public static IServiceCollection AddServices(this IServiceCollection services)
        {
            //Service registration
            services.AddTransient<IUserContextService, UserContextService>();
            services.AddTransient<IUserService, UserService>();
            services.AddTransient<IRoleService, RoleService>();

            return services;
        }
    }
}