using System.Net.Http.Headers;
using System.Security.Claims;
using System.Text;
using System.Text.Encodings.Web;
using eTouristAgencyAPI.Services.Constants;
using eTouristAgencyAPI.Services.Database;
using eTouristAgencyAPI.Services.Database.Models;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;

namespace eTouristAgencyAPI.Authentication
{
    public class BasicAuthenticationHandler : AuthenticationHandler<AuthenticationSchemeOptions>
    {
        private readonly eTouristAgencyDbContext _context;

        public BasicAuthenticationHandler(IOptionsMonitor<AuthenticationSchemeOptions> optionsMonitor,
                                          UrlEncoder urlEncoder,
                                          ILoggerFactory logger,
                                          eTouristAgencyDbContext dbContext) : base(optionsMonitor, logger, urlEncoder)
        {
            _context = dbContext;
        }

        protected override async Task<AuthenticateResult> HandleAuthenticateAsync()
        {
            var authenticationHeader = Context.Request.Headers["Authorization"];

            if (!authenticationHeader.Any()) return AuthenticateResult.Fail("Authentication credentials are not sent.");

            if (!AuthenticationHeaderValue.TryParse(authenticationHeader, out var headerValueBase64String))
            {
                return AuthenticateResult.Fail("Authentication header is not valid.");
            }

            var headerValueBytes = Convert.FromBase64String(headerValueBase64String.Parameter);
            var headerValue = Encoding.UTF8.GetString(headerValueBytes);
            var username = headerValue.Split(':')[0];
            var password = headerValue.Split(':')[1];

            var user = await _context.Users.Include(x => x.Roles).FirstOrDefaultAsync(x => x.Username == username);

            if (user == null || !user.IsActive) return AuthenticateResult.Fail("Provided username or password is not valid");

            var passwordHasher = new PasswordHasher<User>();

            if (passwordHasher.VerifyHashedPassword(user, user.PasswordHash, password) != PasswordVerificationResult.Success)
            {
                return AuthenticateResult.Fail("Provider username or password is not valid.");
            }

            var claims = new List<Claim>()
            {
                new Claim (CustomClaimTypes.Id, user.Id.ToString()),
                new Claim (ClaimTypes.Name, username),
                new Claim (CustomClaimTypes.IsVerified, user.IsVerified.ToString())
            };

            claims.AddRange(user.Roles.Select(x => new Claim(ClaimTypes.Role, x.Name)));

            var identity = new ClaimsIdentity(claims, Scheme.Name);
            var principal = new ClaimsPrincipal(identity);
            var authenticationTiket = new AuthenticationTicket(principal, Scheme.Name);

            return AuthenticateResult.Success(authenticationTiket);
        }
    }
}
