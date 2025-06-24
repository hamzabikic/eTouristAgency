using eTouristAgencyAPI.Models.ResponseModel;

namespace eTouristAgencyAPI.Services.Interfaces
{
    public interface IBaseService<TDbModel, TResponseModel, TSearchModel>
    {
        Task<PaginatedList<TResponseModel>> GetAllAsync(TSearchModel searchModel);
        Task<TResponseModel> GetByIdAsync(Guid id);
    }
}
