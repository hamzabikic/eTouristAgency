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

        public async Task<List<RoomResponse>> UpdateAsync(Guid offerId, List<UpdateRoomRequest> roomList)
        {
            var existingRooms = await _dbContext.Rooms.Where(x => x.OfferId == offerId).ToListAsync();
            var roomsForDelete = existingRooms.Where(x => !roomList.Select(y => y.Id).Contains(x.Id)).ToList();
            var roomsForUpdate = existingRooms.Where(x => roomList.Select(y => y.Id).Contains(x.Id)).ToList();
            var roomsForInsert = _mapper.Map<List<Room>>(roomList.Where(x => x.Id == null).ToList());

            foreach (var item in roomsForInsert)
            {
                item.Id = Guid.NewGuid();
                item.CreatedBy = _userId;
                item.ModifiedBy = _userId;
                item.OfferId = offerId;
            }

            foreach (var item in roomsForUpdate)
            {
                item.ModifiedBy = _userId;
                item.ModifiedOn = DateTime.Now;
                item.OfferId = offerId;

                _mapper.Map<UpdateRoomRequest, Room>(roomList.FirstOrDefault(x => x.Id == item.Id), item);
            }

            await _dbContext.Rooms.AddRangeAsync(roomsForInsert);
            _dbContext.Rooms.RemoveRange(roomsForDelete);
            await _dbContext.SaveChangesAsync();

            var currentRooms = await _dbContext.Rooms.Include(x => x.RoomType).Where(x => x.OfferId == offerId).ToListAsync();

            return _mapper.Map<List<Room>, List<RoomResponse>>(currentRooms);
        }
    }
}
