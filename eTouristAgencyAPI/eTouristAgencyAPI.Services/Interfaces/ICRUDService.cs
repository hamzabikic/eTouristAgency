namespace eTouristAgencyAPI.Services.Interfaces
{
    public interface ICRUDService<TDbModel, TResponseModel, TSearchModel, TInsertModel> : IBaseService<TDbModel, TResponseModel, TSearchModel>
    {
        Task<TResponseModel> AddAsync(TInsertModel insertModel);
    }
}
