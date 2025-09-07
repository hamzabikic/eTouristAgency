using eTouristAgencyAPI.Models.RequestModels.Hotel;
using eTouristAgencyAPI.Models.ResponseModels;
using eTouristAgencyAPI.Models.ResponseModels.Hotel;
using eTouristAgencyAPI.Models.SearchModels;
using eTouristAgencyAPI.Services.Database;
using eTouristAgencyAPI.Services.Database.Models;
using eTouristAgencyAPI.Services.Interfaces;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;

namespace eTouristAgencyAPI.Services
{
    public class HotelService : CRUDService<Hotel, HotelResponse, HotelSearchModel, AddHotelRequest, UpdateHotelRequest>, IHotelService
    {
        private readonly Guid? _userId;
        private readonly IHotelImageService _hotelImageService;

        public HotelService(eTouristAgencyDbContext dbContext,
                            IMapper mapper,
                            IUserContextService userContextService,
                            IHotelImageService hotelImageService) : base(dbContext, mapper)
        {
            _userId = userContextService.GetUserId();
            _hotelImageService = hotelImageService;
        }

        protected override async Task BeforeInsertAsync(AddHotelRequest insertModel, Hotel dbModel)
        {
            dbModel.Id = Guid.NewGuid();
            dbModel.CreatedBy = _userId ?? Guid.Empty;
            dbModel.ModifiedBy = _userId ?? Guid.Empty;

            if (insertModel.Images != null && insertModel.Images.Any())
            {
                int counter = 0;

                dbModel.HotelImages = insertModel.Images.Select(x =>
                {
                    counter++;

                    return new HotelImage
                    {
                        Id = Guid.NewGuid(),
                        ImageBytes = x.ImageBytes,
                        ImageName = x.ImageName,
                        CreatedBy = _userId ?? Guid.Empty,
                        ModifiedBy = _userId ?? Guid.Empty,
                        DisplayOrderWithinHotel = counter
                    };
                }).ToList();
            }
        }

        protected override async Task BeforeUpdateAsync(UpdateHotelRequest updateModel, Hotel dbModel)
        {
            dbModel.ModifiedBy = _userId ?? Guid.Empty;
            dbModel.ModifiedOn = DateTime.Now;
        }

        public override async Task<HotelResponse> UpdateAsync(Guid id, UpdateHotelRequest updateModel)
        {
            var hotelResponse = await base.UpdateAsync(id, updateModel);
            await _hotelImageService.UpdateAsync(id, updateModel.Images);
            hotelResponse.HotelImages = _mapper.Map<List<HotelImageResponse>>(updateModel.Images);

            return hotelResponse;
        }

        protected override async Task<IQueryable<Hotel>> BeforeFetchAllDataAsync(IQueryable<Hotel> queryable, HotelSearchModel searchModel)
        {
            queryable = queryable.Include(x => x.City).ThenInclude(x => x.Country);

            if (!string.IsNullOrEmpty(searchModel.SearchText))
            {
                queryable = queryable.Where(x => x.Name.ToLower().Contains(searchModel.SearchText.ToLower()));
            }

            if (searchModel.CityId != null)
            {
                queryable = queryable.Where(x => x.CityId == searchModel.CityId);
            }

            return queryable;
        }

        protected override async Task<IQueryable<Hotel>> BeforeFetchRecordAsync(IQueryable<Hotel> queryable)
        {
            queryable = queryable.Include(x => x.City).ThenInclude(x => x.Country);

            return queryable;
        }

        public override async Task<PaginatedList<HotelResponse>> GetAllAsync(HotelSearchModel searchModel)
        {
            var paginatedList = await base.GetAllAsync(searchModel);

            foreach(var item in paginatedList.ListOfRecords)
            {
                item.HotelImages = await _dbContext.HotelImages.Where(x => x.HotelId == item.Id).OrderBy(x=> x.DisplayOrderWithinHotel).Select(x => new HotelImageResponse { Id = x.Id }).ToListAsync();
            }

            return paginatedList;
        }

        public override async Task<HotelResponse> GetByIdAsync(Guid id)
        {
            var hotelResponse = await base.GetByIdAsync(id);

            hotelResponse.HotelImages = await _dbContext.HotelImages.Where(x => x.HotelId == hotelResponse.Id).OrderBy(x=> x.DisplayOrderWithinHotel).Select(x => new HotelImageResponse { Id = x.Id }).ToListAsync();

            return hotelResponse;
        }

        public async Task<HotelImage> GetImageByHotelImageIdAsync(Guid hotelImageId)
        {
            var hotelImage = await _dbContext.HotelImages.FindAsync(hotelImageId);

            if (hotelImage == null) throw new Exception("Hotel image with provided id is not found.");

            return hotelImage;
        }
    }
}
