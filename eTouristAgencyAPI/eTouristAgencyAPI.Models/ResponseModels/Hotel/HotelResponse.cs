using System;
using eTouristAgencyAPI.Models.ResponseModels.City;

namespace eTouristAgencyAPI.Models.ResponseModels.Hotel
{
    public class HotelResponse
    {
        public Guid Id { get; set; }

        public string Name { get; set; } 

        public Guid CityId { get; set; }

        public int StarRating { get; set; }

        public virtual CityResponse City { get; set; }
    }
}
