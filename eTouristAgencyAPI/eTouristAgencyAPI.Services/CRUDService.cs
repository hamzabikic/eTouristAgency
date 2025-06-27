using eTouristAgencyAPI.Models.SearchModels;
using eTouristAgencyAPI.Services.Database;
using eTouristAgencyAPI.Services.Interfaces;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;

namespace eTouristAgencyAPI.Services
{
    public abstract class CRUDService<TDbModel, TResponseModel, TSearchModel, TInsertModel, TUpdateModel> : BaseService<TDbModel, TResponseModel, TSearchModel>,
                                                                                                            ICRUDService<TDbModel, TResponseModel, TSearchModel, TInsertModel, TUpdateModel>
                                                                                                            where TDbModel : class where TResponseModel : class where TSearchModel : PaginationModel
    {
        public CRUDService(eTouristAgencyDbContext dbContext, IMapper mapper) : base(dbContext, mapper)
        {
        }

        public virtual async Task<TResponseModel> AddAsync(TInsertModel insertModel)
        {
            var dbModel = _mapper.Map<TInsertModel, TDbModel>(insertModel);

            await BeforeInsertAsync(insertModel, dbModel);

            await _dbContext.AddAsync(dbModel);
            await _dbContext.SaveChangesAsync();

            return _mapper.Map<TDbModel, TResponseModel>(dbModel);
        }

        public virtual async Task<TResponseModel> UpdateAsync(Guid id, TUpdateModel updateModel)
        {
            var queryable = _dbContext.Set<TDbModel>().AsQueryable();
            queryable = await BeforeFetchRecordAsync(queryable);

            var dbModel = await queryable.FirstOrDefaultAsync(x => EF.Property<Guid>(x, "Id") == id);

            if (dbModel == null) throw new Exception("Object with provided id is not find");

            await BeforeUpdateAsync(updateModel, dbModel);

            _mapper.Map<TUpdateModel, TDbModel>(updateModel, dbModel);

            await _dbContext.SaveChangesAsync();

            return _mapper.Map<TDbModel, TResponseModel>(dbModel);
        }

        protected virtual async Task BeforeInsertAsync(TInsertModel insertModel, TDbModel dbModel)
        {
        }

        protected virtual async Task BeforeUpdateAsync(TUpdateModel updateModel, TDbModel dbModel)
        {
        }
    }
}
