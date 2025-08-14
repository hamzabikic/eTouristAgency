using eTouristAgencyAPI.Services.Database;
using MapsterMapper;

namespace eTouristAgencyAPI.Services
{
    public class InactiveOfferStatusService : BaseOfferStatusService
    {
        public InactiveOfferStatusService(IServiceProvider serviceProvider,
                                          eTouristAgencyDbContext dbContext,
                                          IMapper mapper) : base(serviceProvider, dbContext, mapper)
        { }
    }
}