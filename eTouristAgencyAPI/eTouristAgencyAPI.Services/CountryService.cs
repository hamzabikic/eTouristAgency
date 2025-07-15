using eTouristAgencyAPI.Models.RequestModels.Country;
using eTouristAgencyAPI.Models.ResponseModels;
using eTouristAgencyAPI.Models.ResponseModels.Country;
using eTouristAgencyAPI.Models.SearchModels;
using eTouristAgencyAPI.Services.Database;
using eTouristAgencyAPI.Services.Database.Models;
using eTouristAgencyAPI.Services.Interfaces;
using MapsterMapper;

namespace eTouristAgencyAPI.Services
{
    public class CountryService : CRUDService<Country, CountryResponse, CountrySearchModel, AddCountryRequest, UpdateCountryRequest>, ICountryService
    {
        private readonly Guid? _userId;

        public CountryService(eTouristAgencyDbContext dbContext, IMapper mapper, IUserContextService userContextService) : base(dbContext, mapper)
        {
            _userId = userContextService.GetUserId();
        }

        protected override async Task BeforeInsertAsync(AddCountryRequest insertModel, Country dbModel)
        {
            dbModel.Id = Guid.NewGuid();
            dbModel.CreatedBy = _userId;
            dbModel.ModifiedBy = _userId;
        }

        protected override async Task BeforeUpdateAsync(UpdateCountryRequest updateModel, Country dbModel)
        {
            dbModel.ModifiedBy = _userId;
            dbModel.ModifiedOn = DateTime.Now;
        }
    }
}
