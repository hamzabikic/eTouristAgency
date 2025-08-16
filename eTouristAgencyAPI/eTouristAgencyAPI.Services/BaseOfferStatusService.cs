using eTouristAgencyAPI.Models.RequestModels.Offer;
using eTouristAgencyAPI.Models.ResponseModels.Offer;
using eTouristAgencyAPI.Services.Constants;
using eTouristAgencyAPI.Services.Database;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;

namespace eTouristAgencyAPI.Services
{
    public class BaseOfferStatusService
    {
        protected readonly IServiceProvider _serviceProvider;
        protected readonly eTouristAgencyDbContext _dbContext;
        protected readonly IMapper _mapper;

        public BaseOfferStatusService(IServiceProvider serviceProvider, eTouristAgencyDbContext dbContext, IMapper mapper)
        {
            _serviceProvider = serviceProvider;
            _dbContext = dbContext;
            _mapper = mapper;
        }

        public virtual Task<OfferResponse> AddAsync(AddOfferRequest insertModel)
        {
            throw new NotImplementedException();
        }

        public virtual Task<OfferResponse> UpdateAsync(Guid id, UpdateOfferRequest updateModel)
        {
            throw new NotImplementedException();
        }

        public virtual Task ActivateAsync(Guid offerId)
        {
            throw new NotImplementedException();
        }

        public virtual Task DeactivateAsync(Guid offerId)
        {
            throw new NotImplementedException();
        }

        public async Task<BaseOfferStatusService> GetServiceAsync(Guid? offerStatusId = null)
        {
            if (offerStatusId == null) return _serviceProvider.GetService<InitialOfferStatusService>();

            if (!(await _dbContext.EntityCodeValues.AnyAsync(x => x.EntityCodeId == EntityCodes.OfferStatus && x.Id == offerStatusId)))
            {
                throw new Exception("Provided offer status id is not valid.");
            }

            if (offerStatusId == AppConstants.FixedOfferStatusDraft)
                return _serviceProvider.GetRequiredService<DraftOfferStatusService>();

            if (offerStatusId == AppConstants.FixedOfferStatusActive)
                return _serviceProvider.GetRequiredService<ActiveOfferStatusService>();

            if (offerStatusId == AppConstants.FixedOfferStatusInactive)
                return _serviceProvider.GetRequiredService<InactiveOfferStatusService>();

            throw new InvalidOperationException("There is no service for the provided offer status id.");
        }
    }
}
