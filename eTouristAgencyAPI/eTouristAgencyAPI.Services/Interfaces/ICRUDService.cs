namespace eTouristAgencyAPI.Services.Interfaces
{
    public interface ICRUDService<TDbModel, TResponseModel, TSearchModel, TInsertModel, TUpdateModel> : IBaseService<TDbModel, TResponseModel, TSearchModel>
    {
        Task<TResponseModel> AddAsync(TInsertModel insertModel);
        Task<TResponseModel> UpdateAsync(Guid id, TUpdateModel updateModel);
    }
}
