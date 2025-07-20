using eTouristAgencyAPI.Models.RequestModels.EntityCodeValue;
using eTouristAgencyAPI.Models.ResponseModels.EntityCodeValue;

namespace eTouristAgencyAPI.Services.Interfaces
{
    public interface IEntityCodeValueService
    {
        Task<List<EntityCodeValueResponse>> GetAllByEntityCodeIdAsync(Guid entityCodeId);
        Task<EntityCodeValueResponse> AddAsync(Guid entityCodeId, AddEntityCodeValueRequest insertModel);
    }
}
