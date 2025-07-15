using eTouristAgencyAPI.Models.RequestModels.City;
using eTouristAgencyAPI.Models.ResponseModels.City;
using eTouristAgencyAPI.Models.SearchModels;
using eTouristAgencyAPI.Services.Database;
using eTouristAgencyAPI.Services.Database.Models;
using eTouristAgencyAPI.Services.Interfaces;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;

namespace eTouristAgencyAPI.Services
{
    public class CityService : CRUDService<City, CityResponse, CitySearchModel, AddCityRequest, UpdateCityRequest>, ICityService
    {
        private readonly Guid? _userId;

        public CityService(eTouristAgencyDbContext dbContext, IMapper mapper, IUserContextService userContextService) : base(dbContext, mapper)
        {
            _userId = userContextService.GetUserId();
        }

        protected override async Task BeforeInsertAsync(AddCityRequest insertModel, City dbModel)
        {
            dbModel.Id = Guid.NewGuid();
            dbModel.CreatedBy = _userId;
            dbModel.ModifiedBy = _userId;
        }

        protected override async Task BeforeUpdateAsync(UpdateCityRequest updateModel, City dbModel)
        {
            dbModel.ModifiedBy = _userId;
            dbModel.ModifiedOn = DateTime.Now;
        }

        protected override async Task<IQueryable<City>> BeforeFetchAllDataAsync(IQueryable<City> queryable, CitySearchModel searchModel)
        {
            queryable = queryable.Include(x => x.Country);

            return queryable;
        }

        protected override async Task<IQueryable<City>> BeforeFetchRecordAsync(IQueryable<City> queryable)
        {
            queryable = queryable.Include(x => x.Country);

            return queryable;
        }
    }
}
