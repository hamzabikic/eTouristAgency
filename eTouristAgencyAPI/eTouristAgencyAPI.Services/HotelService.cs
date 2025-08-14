using eTouristAgencyAPI.Models.RequestModels.Hotel;
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
                dbModel.HotelImages = insertModel.Images.Select(x => new HotelImage
                {
                    Id = Guid.NewGuid(),
                    ImageBytes = x,
                    CreatedBy = _userId ?? Guid.Empty,
                    ModifiedBy = _userId ?? Guid.Empty
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
            queryable = queryable.Include(x => x.City).ThenInclude(x => x.Country).Include(x => x.HotelImages);

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
            queryable = queryable.Include(x => x.City).ThenInclude(x => x.Country).Include(x => x.HotelImages);

            return queryable;
        }
    }
}
