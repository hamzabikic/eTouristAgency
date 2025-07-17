using eTouristAgencyAPI.Models.RequestModels.Room;
using eTouristAgencyAPI.Models.ResponseModels.Room;
using eTouristAgencyAPI.Services.Database;
using eTouristAgencyAPI.Services.Database.Models;
using eTouristAgencyAPI.Services.Interfaces;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;

namespace eTouristAgencyAPI.Services
{
    public class RoomService : IRoomService
    {
        private readonly eTouristAgencyDbContext _dbContext;
        private readonly IMapper _mapper;

        private readonly Guid _userId;

        public RoomService(eTouristAgencyDbContext dbContext, IMapper mapper, IUserContextService userContextService)
        {
            _dbContext = dbContext;
            _mapper = mapper;

            _userId = userContextService.GetUserId() ?? Guid.Empty;
        }

        public async Task<List<RoomResponse>> AddByOfferIdAsync(Guid offerId, List<AddRoomRequest> roomList)
        {
            var rooms = _mapper.Map<List<AddRoomRequest>, List<Room>>(roomList);

            foreach (var item in rooms)
            {
                item.Id = Guid.NewGuid();
                item.CreatedBy = _userId;
                item.ModifiedBy = _userId;
                item.OfferId = offerId;
            }

            await _dbContext.Rooms.AddRangeAsync(rooms);
            await _dbContext.SaveChangesAsync();

            return _mapper.Map<List<Room>, List<RoomResponse>>(rooms);
        }

        public async Task<List<RoomResponse>> UpdateAsync(List<UpdateRoomRequest> roomList)
        {
            var rooms = _mapper.Map<List<UpdateRoomRequest>, List<Room>>(roomList);

            foreach (var item in rooms)
            {
                item.ModifiedBy = _userId;
                item.ModifiedOn = DateTime.Now;
            }

            _dbContext.Rooms.UpdateRange(rooms);
            await _dbContext.SaveChangesAsync();

            return _mapper.Map<List<Room>, List<RoomResponse>>(rooms);
        }

        public async Task<List<RoomResponse>> GetAllByOfferIdAsync(Guid offerId)
        {
            var rooms = await _dbContext.Rooms.Where(x => x.OfferId == offerId).ToListAsync();

            return _mapper.Map<List<Room>, List<RoomResponse>>(rooms);
        }
    }
}
