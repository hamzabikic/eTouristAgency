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

        public HotelService(eTouristAgencyDbContext dbContext, IMapper mapper, IUserContextService userContextService) : base(dbContext, mapper)
        {
            _userId = userContextService.GetUserId();
        }

        protected override async Task BeforeInsertAsync(AddHotelRequest insertModel, Hotel dbModel)
        {
            dbModel.Id = Guid.NewGuid();
            dbModel.CreatedBy = _userId ?? Guid.Empty;
            dbModel.ModifiedBy = _userId ?? Guid.Empty;
        }

        protected override async Task BeforeUpdateAsync(UpdateHotelRequest updateModel, Hotel dbModel)
        {
            dbModel.ModifiedBy = _userId ?? Guid.Empty;
            dbModel.ModifiedOn = DateTime.Now;
        }

        protected override async Task<IQueryable<Hotel>> BeforeFetchAllDataAsync(IQueryable<Hotel> queryable, HotelSearchModel searchModel)
        {
            queryable = queryable.Include(x => x.City).ThenInclude(x => x.Country);

            return queryable;
        }

        protected override async Task<IQueryable<Hotel>> BeforeFetchRecordAsync(IQueryable<Hotel> queryable)
        {
            queryable = queryable.Include(x => x.City).ThenInclude(x => x.Country);

            return queryable;
        }
    }
}
