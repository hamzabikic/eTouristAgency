using eTouristAgencyAPI.Services.Database;
using eTouristAgencyAPI.Services.Database.Models;
using eTouristAgencyAPI.Services.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace eTouristAgencyAPI.Services
{
    public class OfferContentBasedService : IOfferContentBasedService
    {
        private readonly eTouristAgencyDbContext _dbContext;

        public OfferContentBasedService(eTouristAgencyDbContext dbContext)
        {
            _dbContext = dbContext;
        }

        public async Task<List<User>> GetUsersForOfferAsync(Offer offer)
        {
            var boardTypeId = offer.BoardTypeId.ToString();
            var hotelId = offer.HotelId.ToString();
            var cityId = offer.Hotel.CityId.ToString();
            var countryId = offer.Hotel.City.CountryId.ToString();

            var userTags = await _dbContext.UserTags.Include(x => x.User).Where(x => x.CreatedOn > DateTime.Now.AddYears(-1) &&
                                                                                    (x.Tag == boardTypeId ||
                                                                                     x.Tag == hotelId ||
                                                                                     x.Tag == cityId ||
                                                                                     x.Tag == countryId)).ToListAsync();

            var users = userTags.DistinctBy(x=> x.UserId).Select(x => x.User).ToList();
            List<KeyValuePair<User, int>> countOfMutualTagsPerUser = new List<KeyValuePair<User, int>>();

            foreach (var user in users)
            {
                int countOfMutualTags = 0;

                foreach (var userTag in userTags.Where(x => x.UserId == user.Id))
                {
                    if (userTag.Tag == boardTypeId ||
                        userTag.Tag == hotelId ||
                        userTag.Tag == cityId ||
                        userTag.Tag == countryId)
                    {
                        countOfMutualTags++;
                    }
                }

                countOfMutualTagsPerUser.Add(new KeyValuePair<User, int>(user, countOfMutualTags));
            }

            return countOfMutualTagsPerUser.OrderByDescending(x => x.Value).Take(100).Select(x => x.Key).ToList();
        }
    }
}
