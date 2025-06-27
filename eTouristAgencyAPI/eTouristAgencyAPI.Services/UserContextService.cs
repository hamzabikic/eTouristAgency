using eTouristAgencyAPI.Services.Constants;
using eTouristAgencyAPI.Services.Interfaces;
using Microsoft.AspNetCore.Http;

namespace eTouristAgencyAPI.Services
{
    public class UserContextService : IUserContextService
    {
        private readonly IHttpContextAccessor _httpContext;

        public UserContextService(IHttpContextAccessor httpContext)
        {
            _httpContext = httpContext;
        }

        public Guid? GetUserId()
        {
            var user = _httpContext.HttpContext?.User;

            if (user == null || !user.Identity.IsAuthenticated) return null;

            return new Guid(user.Claims.First(x => x.Type == CustomClaimTypes.Id).Value);
        }

        public bool UserHasRole(string roleName)
        {
            var user = _httpContext.HttpContext?.User;

            if (user == null || !user.Identity.IsAuthenticated) return false;

            return user.IsInRole(roleName);
        }

        public string GetUsername()
        {
            var user = _httpContext.HttpContext?.User;

            if (user == null || !user.Identity.IsAuthenticated) return null;

            return user.Identity.Name;
        }
    }
}