using eTouristAgencyAPI.Models.RequestModels.Passenger;
using eTouristAgencyAPI.Models.ResponseModels.Passenger;
using eTouristAgencyAPI.Services.Database;
using eTouristAgencyAPI.Services.Database.Models;
using eTouristAgencyAPI.Services.Interfaces;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;

namespace eTouristAgencyAPI.Services
{
    public class PassengerService : IPassengerService
    {
        private readonly eTouristAgencyDbContext _dbContext;
        private readonly IMapper _mapper;

        private readonly Guid? _userId;

        public PassengerService(eTouristAgencyDbContext dbContext, IMapper mapper, IUserContextService userContextService)
        {
            _dbContext = dbContext;
            _mapper = mapper;
            _userId = userContextService.GetUserId();
        }

        public async Task<List<PassengerResponse>> AddByReservationIdAsync(Guid reservationId, List<AddPassengerRequest> passengerList)
        {
            var passengers = _mapper.Map<List<Passenger>>(passengerList);

            passengers.ForEach(passenger =>
            {
                passenger.Id = Guid.NewGuid();
                passenger.ReservationId = reservationId;
                passenger.CreatedBy = _userId ?? Guid.Empty;
                passenger.ModifiedBy = _userId ?? Guid.Empty;
            });

            await _dbContext.Passengers.AddRangeAsync(passengers);
            await _dbContext.SaveChangesAsync();

            return _mapper.Map<List<PassengerResponse>>(passengers);
        }

        public async Task<List<PassengerResponse>> UpdateByReservationIdAsync(Guid reservationId, List<UpdatePassengerRequest> passengerList)
        {
            var storagedPassengers = await _dbContext.Passengers.Where(x => x.ReservationId == reservationId).ToListAsync();
            var storagedPassengersForUpdate = storagedPassengers.Where(x => passengerList.Select(y => y.Id).Contains(x.Id)).ToList();
            var storagedPassengersForDelete = storagedPassengers.Where(x => !passengerList.Where(y => y.Id != null).Select(y => y.Id).Contains(x.Id)).ToList();

            var passengersForInsert = _mapper.Map<List<Passenger>>(passengerList.Where(x => x.Id == null).ToList());
            passengersForInsert.ForEach(x =>
            {
                x.Id = Guid.NewGuid();
                x.ReservationId = reservationId;
                x.CreatedBy = _userId ?? Guid.Empty;
                x.ModifiedBy = _userId ?? Guid.Empty;
            });

            storagedPassengersForUpdate.ForEach(x =>
            {
                _mapper.Map<UpdatePassengerRequest, Passenger>(passengerList.First(y => y.Id == x.Id), x);

                x.ModifiedBy = _userId ?? Guid.Empty;
                x.ModifiedOn = DateTime.Now;
            });

            await _dbContext.Passengers.AddRangeAsync(passengersForInsert);
            _dbContext.Passengers.RemoveRange(storagedPassengersForDelete);
            await _dbContext.SaveChangesAsync();

            return _mapper.Map<List<PassengerResponse>>(storagedPassengersForUpdate.Union(passengersForInsert).ToList());
        }
    }
}
