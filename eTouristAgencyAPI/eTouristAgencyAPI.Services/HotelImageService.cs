using eTouristAgencyAPI.Models.RequestModels.Hotel;
using eTouristAgencyAPI.Services.Database;
using eTouristAgencyAPI.Services.Database.Models;
using eTouristAgencyAPI.Services.Interfaces;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;

namespace eTouristAgencyAPI.Services
{
    public class HotelImageService : IHotelImageService
    {
        private readonly eTouristAgencyDbContext _dbContext;
        private readonly IMapper _mapper;
        private readonly Guid? _userId;

        public HotelImageService(eTouristAgencyDbContext dbContext, IMapper mapper, IUserContextService userContextService)
        {
            _dbContext = dbContext;
            _mapper = mapper;
            _userId = userContextService.GetUserId();
        }

        public async Task UpdateAsync(Guid hotelId, List<UpdateHotelImageRequest> hotelImages)
        {
            for(int i =0; i< hotelImages.Count; i++)
            {
                hotelImages[i].DisplayOrderWithinHotel = i + 1;
            }

            var storagedImages = await _dbContext.HotelImages.Where(x => x.HotelId == hotelId).ToListAsync();
            var imagesForUpdate = storagedImages.Where(x => hotelImages.Select(y => y.Id).Contains(x.Id)).ToList();
            var imagesForDelete = storagedImages.Where(x => !hotelImages.Select(y => y.Id).Contains(x.Id)).ToList();
            var imagesForInsert = _mapper.Map<List<HotelImage>>(hotelImages.Where(x => x.Id == null).ToList());

            foreach (var item in imagesForUpdate)
            {
                item.ModifiedOn = DateTime.Now;
                item.ModifiedBy = _userId ?? Guid.Empty;

                _mapper.Map<UpdateHotelImageRequest, HotelImage>(hotelImages.FirstOrDefault(x => x.Id == item.Id), item);
            }

            foreach (var item in imagesForInsert)
            {
                item.Id = Guid.NewGuid();
                item.CreatedBy = _userId ?? Guid.Empty;
                item.ModifiedBy = _userId ?? Guid.Empty;
                item.HotelId = hotelId;
            }

            await _dbContext.HotelImages.AddRangeAsync(imagesForInsert);
            _dbContext.HotelImages.RemoveRange(imagesForDelete);

            await _dbContext.SaveChangesAsync();
        }
    }
}
