using eTouristAgencyAPI.Services.Database;
using eTouristAgencyAPI.Services.Database.Models;
using eTouristAgencyAPI.Services.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace eTouristAgencyAPI.Services
{
    public class UserTagService : IUserTagService
    {
        private readonly eTouristAgencyDbContext _dbContext;

        public UserTagService(eTouristAgencyDbContext dbContext)
        {
            _dbContext = dbContext;
        }

        public async Task AddTagsByUserIdAsync(Guid offerId, Guid userId)
        {
            var offer = await _dbContext.Offers.Include(x => x.Hotel.City.Country).FirstOrDefaultAsync(x => x.Id == offerId);

            if (offer == null) throw new Exception("Offer with provided id is not found.");

            var storagedUserTags = await _dbContext.UserTags.Where(x => x.UserId == userId).ToListAsync();
            var userTags = new List<UserTag>();

            var boardTypeTag = storagedUserTags.Find(x => x.Tag == offer.BoardTypeId.ToString());
            AddOrUpdateUserTag(userTags, boardTypeTag, offer.BoardTypeId.ToString(), userId);

            var hotelTag = storagedUserTags.Find(x => x.Tag == offer.HotelId.ToString());
            AddOrUpdateUserTag(userTags, hotelTag, offer.HotelId.ToString(), userId);

            var cityTag = storagedUserTags.Find(x => x.Tag == offer.Hotel.CityId.ToString());
            AddOrUpdateUserTag(userTags, cityTag, offer.Hotel.CityId.ToString(), userId);

            var countryTag = storagedUserTags.Find(x => x.Tag == offer.Hotel.City.CountryId.ToString());
            AddOrUpdateUserTag(userTags, countryTag, offer.Hotel.City.CountryId.ToString(), userId);

            await _dbContext.UserTags.AddRangeAsync(userTags);
            await _dbContext.SaveChangesAsync();
        }

        private void AddOrUpdateUserTag(List<UserTag> userTags, UserTag userTag, String tag, Guid userId)
        {
            if (userTag == null)
            {
                userTags.Add(new UserTag
                {
                    Id = Guid.NewGuid(),
                    UserId = userId,
                    Tag = tag
                });
            }
            else
            {
                userTag.CreatedOn = DateTime.Now;
            }
        }
    }
}
