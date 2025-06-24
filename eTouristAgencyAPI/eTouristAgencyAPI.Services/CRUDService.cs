using eTouristAgencyAPI.Models.SearchModels;
using eTouristAgencyAPI.Services.Database;
using MapsterMapper;

namespace eTouristAgencyAPI.Services
{
    public class CRUDService<TDbModel, TResponseModel, TSearchModel, TInsertModel> : BaseService<TDbModel, TResponseModel, TSearchModel>
        where TDbModel : class where TResponseModel : class where TSearchModel : BaseSearchModel
    {
        public CRUDService(eTouristAgencyDbContext dbContext, IMapper mapper) : base(dbContext, mapper)
        {
        }

        public async Task<TResponseModel> AddAsync(TInsertModel insertModel)
        {
            var dbModel = _mapper.Map<TInsertModel, TDbModel>(insertModel);

            BeforeInsert(insertModel, dbModel);

            await _dbContext.AddAsync(dbModel);
            await _dbContext.SaveChangesAsync();

            return _mapper.Map<TDbModel, TResponseModel>(dbModel);
        }

        protected virtual void BeforeInsert(TInsertModel insertModel, TDbModel dbModel)
        {
        }
    }
}
