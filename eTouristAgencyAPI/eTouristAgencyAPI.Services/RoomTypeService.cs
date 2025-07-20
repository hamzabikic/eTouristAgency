using eTouristAgencyAPI.Models.RequestModels.RoomType;
using eTouristAgencyAPI.Models.ResponseModels.RoomType;
using eTouristAgencyAPI.Models.SearchModels;
using eTouristAgencyAPI.Services.Database;
using eTouristAgencyAPI.Services.Database.Models;
using eTouristAgencyAPI.Services.Interfaces;
using MapsterMapper;

namespace eTouristAgencyAPI.Services
{
    public class RoomTypeService : CRUDService<RoomType, RoomTypeResponse, RoomTypeSearchModel, AddRoomTypeRequest, UpdateRoomTypeRequest>, IRoomTypeService
    {
        private readonly Guid? _userId;

        public RoomTypeService(eTouristAgencyDbContext dbContext, IMapper mapper, IUserContextService userContextService) : base(dbContext, mapper)
        {
            _userId = userContextService.GetUserId();
        }

        protected override async Task BeforeInsertAsync(AddRoomTypeRequest insertModel, RoomType dbModel)
        {
            dbModel.Id = Guid.NewGuid();
            dbModel.CreatedBy = _userId;
            dbModel.ModifiedBy = _userId;
        }

        protected override async Task BeforeUpdateAsync(UpdateRoomTypeRequest updateModel, RoomType dbModel)
        {
            dbModel.ModifiedBy = _userId;
            dbModel.ModifiedOn = DateTime.Now;
        }
    }
}
