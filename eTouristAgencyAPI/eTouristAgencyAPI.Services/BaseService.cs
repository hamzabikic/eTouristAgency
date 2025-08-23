using eTouristAgencyAPI.Models.ResponseModels;
using eTouristAgencyAPI.Models.SearchModels;
using eTouristAgencyAPI.Services.Database;
using eTouristAgencyAPI.Services.Interfaces;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;

namespace eTouristAgencyAPI.Services
{
    public abstract class BaseService<TDbModel, TResponseModel, TSearchModel> : IBaseService<TDbModel, TResponseModel, TSearchModel>
                 where TDbModel : class where TResponseModel : class where TSearchModel : PaginationModel
    {
        protected readonly eTouristAgencyDbContext _dbContext;
        protected readonly IMapper _mapper;

        public BaseService(eTouristAgencyDbContext dbContext, IMapper mapper)
        {
            _dbContext = dbContext;
            _mapper = mapper;
        }

        public virtual async Task<PaginatedList<TResponseModel>> GetAllAsync(TSearchModel searchModel)
        {
            var query = _dbContext.Set<TDbModel>().AsQueryable();
            query = await BeforeFetchAllDataAsync(query, searchModel);

            var countOfAllRecords = await query.CountAsync();

            if (countOfAllRecords == 0) return new PaginatedList<TResponseModel>()
            {
                ListOfRecords = new List<TResponseModel>(),
                TotalPages = 0
            };

            query = query.Skip((searchModel.Page - 1) * searchModel.RecordsPerPage);
            query = query.Take(searchModel.RecordsPerPage);

            var listOfRecords = await query.ToListAsync();

            await AfterFetchAllDataAsync(listOfRecords);

            var listOfResponseModel = _mapper.Map<List<TDbModel>, List<TResponseModel>>(listOfRecords);

            int totalPages = countOfAllRecords % searchModel.RecordsPerPage == 0 ? countOfAllRecords / searchModel.RecordsPerPage : countOfAllRecords / searchModel.RecordsPerPage + 1;

            return new PaginatedList<TResponseModel>
            {
                ListOfRecords = listOfResponseModel,
                TotalPages = totalPages
            };
        }

        public virtual async Task<TResponseModel> GetByIdAsync(Guid id)
        {
            var query = _dbContext.Set<TDbModel>().AsQueryable();
            query = await BeforeFetchRecordAsync(query);

            var record = await query.FirstOrDefaultAsync(e => EF.Property<Guid>(e, "Id") == id);

            if (record == null) throw new Exception("Record with provided id is not found");

            await AfterFetchRecordAsync(record);

            return _mapper.Map<TResponseModel>(record);
        }

        protected virtual async Task<IQueryable<TDbModel>> BeforeFetchAllDataAsync(IQueryable<TDbModel> queryable, TSearchModel searchModel)
        {
            return queryable;
        }

        protected virtual async Task<IQueryable<TDbModel>> BeforeFetchRecordAsync(IQueryable<TDbModel> queryable)
        {
            return queryable;
        }

        protected virtual async Task AfterFetchAllDataAsync(List<TDbModel> listOfRecords) { }

        protected virtual async Task AfterFetchRecordAsync(TDbModel dbModel) { }
    }
}
