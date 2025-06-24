using eTouristAgencyAPI.Services.Database;
using eTouristAgencyAPI.Services.Database.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;

namespace eTouristAgencyAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class InitialDataController : ControllerBase
    {
        private readonly eTouristAgencyDbContext _dbContext;

        public InitialDataController(eTouristAgencyDbContext dbContext)
        {
            _dbContext = dbContext;
        }

        [HttpPost]
        public async Task<IActionResult> InsertInitialData()
        {
            var role = new Role
            {
                Id = Guid.NewGuid(),
                Name = "Admin"
            };

            await _dbContext.AddAsync(role);

            var passwordHasher = new PasswordHasher<User>();
            var user = new User
            {
                Id = Guid.NewGuid(),
                Username = "hamza",
                Email = "hamza.bikic@edu.fit.ba",
                PhoneNumber = "066261961",
                FirstName = "Hamza",
                LastName = "Bikić",
                IsActive = true,
                IsVerified = true
            };

            user.PasswordHash = passwordHasher.HashPassword(user, "hamza123");
            user.Roles.Add(role);
            await _dbContext.AddAsync(user);
            await _dbContext.SaveChangesAsync();
            return Ok();
        }
    }
}
