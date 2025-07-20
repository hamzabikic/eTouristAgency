using eTouristAgencyAPI.Models.RequestModels.EntityCodeValue;
using eTouristAgencyAPI.Models.ResponseModels.EntityCodeValue;
using eTouristAgencyAPI.Services.Database;
using eTouristAgencyAPI.Services.Database.Models;
using eTouristAgencyAPI.Services.Interfaces;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.Identity.Client;

namespace eTouristAgencyAPI.Services
{
    public class EntityCodeValueService : IEntityCodeValueService
    {
        private readonly eTouristAgencyDbContext _dbContext;
        private readonly IMapper _mapper;

        private readonly Guid? _userId;

        public EntityCodeValueService(eTouristAgencyDbContext dbContext, IMapper mapper, IUserContextService userContextService)
        {
            _dbContext = dbContext;
            _mapper = mapper;
            _userId = userContextService.GetUserId();
        }

        public async Task<List<EntityCodeValueResponse>> GetAllByEntityCodeIdAsync(Guid entityCodeId)
        {
            var entityCodeValues = await _dbContext.EntityCodeValues.Where(x => x.EntityCodeId == entityCodeId).ToListAsync();

            var entityCodeValueList = _mapper.Map<List<EntityCodeValue>, List<EntityCodeValueResponse>>(entityCodeValues);

            return entityCodeValueList;
        }

        public async Task<EntityCodeValueResponse> AddAsync(Guid entityCodeId, AddEntityCodeValueRequest insertModel)
        {
            var entityCodeValue = _mapper.Map<AddEntityCodeValueRequest, EntityCodeValue>(insertModel);

            entityCodeValue.Id = Guid.NewGuid();
            entityCodeValue.EntityCodeId = entityCodeId;
            entityCodeValue.CreatedBy = _userId;
            entityCodeValue.ModifiedBy = _userId;

            await _dbContext.EntityCodeValues.AddAsync(entityCodeValue);
            await _dbContext.SaveChangesAsync();

            return _mapper.Map<EntityCodeValue, EntityCodeValueResponse>(entityCodeValue);
        }
    }
}
