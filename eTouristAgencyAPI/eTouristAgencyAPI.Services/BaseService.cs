using eTouristAgencyAPI.Models.ResponseModel;
using eTouristAgencyAPI.Models.SearchModels;
using eTouristAgencyAPI.Services.Database;
using eTouristAgencyAPI.Services.Interfaces;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;

namespace eTouristAgencyAPI.Services
{
    public abstract class BaseService<TDbModel, TResponseModel, TSearchModel> : IBaseService<TDbModel, TResponseModel, TSearchModel>
                 where TDbModel : class where TResponseModel : class where TSearchModel : BaseSearchModel
    {
        protected readonly eTouristAgencyDbContext _dbContext;
        protected readonly IMapper _mapper;

        public BaseService(eTouristAgencyDbContext dbContext, IMapper mapper)
        {
            _dbContext = dbContext;
            _mapper = mapper;
        }

        public async Task<PaginatedList<TResponseModel>> GetAllAsync(TSearchModel searchModel)
        {
            var query = _dbContext.Set<TDbModel>().AsQueryable();
            query = BeforeFetchAllData(query);

            var countOfAllRecords = await query.CountAsync();

            if (countOfAllRecords == 0) return new PaginatedList<TResponseModel>()
            {
                listOfRecords = new List<TResponseModel>(),
                TotalPages = 0
            };

            query = query.Skip((searchModel.Page - 1) * searchModel.RecordsPerPage);
            query = query.Take(searchModel.RecordsPerPage);

            var listOfRecords = await query.ToListAsync();
            var listOfResponseModel = _mapper.Map<List<TDbModel>, List<TResponseModel>>(listOfRecords);

            int totalPages = countOfAllRecords % searchModel.RecordsPerPage == 0 ? countOfAllRecords / searchModel.RecordsPerPage : countOfAllRecords / searchModel.RecordsPerPage + 1;

            return new PaginatedList<TResponseModel>
            {
                listOfRecords = listOfResponseModel,
                TotalPages = totalPages
            };
        }

        public async Task<TResponseModel> GetByIdAsync(Guid id)
        {
            var query = _dbContext.Set<TDbModel>().AsQueryable();
            query = BeforeFetchRecord(query);

            var record = await query.FirstOrDefaultAsync(e => EF.Property<Guid>(e, "Id") == id);

            return _mapper.Map<TResponseModel>(record);
        }

        protected virtual IQueryable<TDbModel> BeforeFetchAllData(IQueryable<TDbModel> queryable)
        {
            return queryable;
        }

        protected virtual IQueryable<TDbModel> BeforeFetchRecord(IQueryable<TDbModel> queryable)
        {
            return queryable;
        }
    }
}
