using eTouristAgencyAPI.Models.RequestModels.Passenger;
using eTouristAgencyAPI.Models.ResponseModels.Passenger;
using eTouristAgencyAPI.Services.Constants;
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
        private readonly bool _isAdmin;

        public PassengerService(eTouristAgencyDbContext dbContext, IMapper mapper, IUserContextService userContextService)
        {
            _dbContext = dbContext;
            _mapper = mapper;
            _userId = userContextService.GetUserId();
            _isAdmin = userContextService.UserHasRole(Roles.Admin);
        }

        public async Task<List<PassengerResponse>> AddByReservationIdAsync(Guid reservationId, List<AddPassengerRequest> passengerList)
        {
            var passengers = _mapper.Map<List<Passenger>>(passengerList);

            for (int i = 0; i < passengers.Count; i++)
            {
                passengers[i].Id = Guid.NewGuid();
                passengers[i].ReservationId = reservationId;
                passengers[i].CreatedBy = _userId ?? Guid.Empty;
                passengers[i].ModifiedBy = _userId ?? Guid.Empty;
                passengers[i].DisplayOrderWithinReservation = i + 1;
                passengers[i].PassengerDocument.CreatedBy = _userId ?? Guid.Empty;
                passengers[i].PassengerDocument.ModifiedBy = _userId ?? Guid.Empty;
            }

            await _dbContext.Passengers.AddRangeAsync(passengers);
            await _dbContext.SaveChangesAsync();

            return _mapper.Map<List<PassengerResponse>>(passengers);
        }

        public async Task<List<PassengerResponse>> UpdateByReservationIdAsync(Guid reservationId, List<UpdatePassengerRequest> passengerList)
        {
            for (int i = 0; i < passengerList.Count; i++)
            {
                passengerList[i].DisplayOrderWithinReservation = i + 1;
            }

            var storagedPassengers = await _dbContext.Passengers.Include(x => x.PassengerDocument).Where(x => x.ReservationId == reservationId).ToListAsync();
            var storagedPassengersForUpdate = storagedPassengers.Where(x => passengerList.Select(y => y.Id).Contains(x.Id)).ToList();
            var storagedPassengersForDelete = storagedPassengers.Where(x => !passengerList.Where(y => y.Id != null).Select(y => y.Id).Contains(x.Id)).ToList();

            var passengersForInsert = _mapper.Map<List<Passenger>>(passengerList.Where(x => x.Id == null).ToList());

            passengersForInsert.ForEach(x =>
            {
                x.Id = Guid.NewGuid();
                x.ReservationId = reservationId;
                x.CreatedBy = _userId ?? Guid.Empty;
                x.ModifiedBy = _userId ?? Guid.Empty;
                x.PassengerDocument.CreatedBy = _userId ?? Guid.Empty;
                x.PassengerDocument.ModifiedBy = _userId ?? Guid.Empty;
            });

            storagedPassengersForUpdate.ForEach(x =>
            {
                bool documentExists = x.PassengerDocument != null;
                _mapper.Map<UpdatePassengerRequest, Passenger>(passengerList.First(y => y.Id == x.Id), x);

                x.ModifiedBy = _userId ?? Guid.Empty;
                x.ModifiedOn = DateTime.Now;

                if (documentExists)
                {
                    x.PassengerDocument.ModifiedBy = _userId ?? Guid.Empty;
                    x.PassengerDocument.ModifiedOn = DateTime.Now;
                }
                else
                {
                    x.PassengerDocument.CreatedBy = _userId ?? Guid.Empty;
                    x.PassengerDocument.ModifiedBy = _userId ?? Guid.Empty;
                }
            });

            await _dbContext.Passengers.AddRangeAsync(passengersForInsert);
            _dbContext.PassengerDocuments.RemoveRange(storagedPassengersForDelete.Where(x => x.PassengerDocument != null).Select(x => x.PassengerDocument));
            _dbContext.Passengers.RemoveRange(storagedPassengersForDelete);
            await _dbContext.SaveChangesAsync();

            return _mapper.Map<List<PassengerResponse>>(storagedPassengersForUpdate.Union(passengersForInsert).ToList());
        }

        public async Task<PassengerDocument> GetDocumentByIdAsync(Guid id)
        {
            var passengerDocument = await _dbContext.PassengerDocuments.FindAsync(id);

            if (passengerDocument == null) throw new Exception("Passenger document with provided id is not found.");
            if (!_isAdmin && passengerDocument.CreatedBy != _userId) throw new Exception("You don't have a permission to see this document.");

            return passengerDocument;
        }
    }
}
