using eTouristAgencyAPI.Models.RequestModels.OfferDiscount;
using eTouristAgencyAPI.Models.ResponseModels.OfferDiscount;
using eTouristAgencyAPI.Services.Constants;
using eTouristAgencyAPI.Services.Database;
using eTouristAgencyAPI.Services.Database.Models;
using eTouristAgencyAPI.Services.Interfaces;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;

namespace eTouristAgencyAPI.Services
{
    public class OfferDiscountService : IOfferDiscountService
    {
        private readonly Guid? _userId;
        private readonly IMapper _mapper;
        private readonly eTouristAgencyDbContext _dbContext;

        public OfferDiscountService(eTouristAgencyDbContext dbContext, IMapper mapper, IUserContextService userContextService)
        {
            _userId = userContextService.GetUserId();
            _dbContext = dbContext;
            _mapper = mapper;
        }

        public async Task<List<OfferDiscountResponse>> AddByOfferIdAsync(Guid offerId, List<AddOfferDiscountRequest> offerDiscountList)
        {
            if (offerDiscountList.Where(x => x.DiscountTypeId == AppConstants.FixedOfferDiscountTypeFirstMinute).Count() > 1 ||
                offerDiscountList.Where(x => x.DiscountTypeId == AppConstants.FixedOfferDiscountTypeLastMinute).Count() > 1)
                throw new Exception("You can provide only one first minute and last minute discount.");

            var storagedOfferDiscounts = await _dbContext.OfferDiscounts.Where(x => x.OfferId == offerId).ToListAsync();

            if (storagedOfferDiscounts.Any(x => x.DiscountTypeId == AppConstants.FixedOfferDiscountTypeFirstMinute) &&
                storagedOfferDiscounts.Any(x => x.DiscountTypeId == AppConstants.FixedOfferDiscountTypeLastMinute))
                throw new Exception("You can provide only one first minute and last minute discount.");

            var offerDiscounts = _mapper.Map<List<AddOfferDiscountRequest>, List<OfferDiscount>>(offerDiscountList);

            foreach (var offerDiscount in offerDiscounts)
            {
                offerDiscount.Id = Guid.NewGuid();
                offerDiscount.OfferId = offerId;
                offerDiscount.CreatedBy = _userId ?? Guid.Empty;
                offerDiscount.ModifiedBy = _userId ?? Guid.Empty;
            }

            await _dbContext.OfferDiscounts.AddRangeAsync(offerDiscounts);
            await _dbContext.SaveChangesAsync();

            return _mapper.Map<List<OfferDiscount>, List<OfferDiscountResponse>>(offerDiscounts);
        }

        public async Task<List<OfferDiscountResponse>> UpdateAsync(List<UpdateOfferDiscountRequest> offerDiscountList)
        {
            var offerDiscounts = _mapper.Map<List<UpdateOfferDiscountRequest>, List<OfferDiscount>>(offerDiscountList);

            foreach (var offerDiscount in offerDiscounts)
            {
                offerDiscount.ModifiedBy = _userId ?? Guid.Empty;
                offerDiscount.ModifiedOn = DateTime.Now;
            }

            _dbContext.OfferDiscounts.UpdateRange(offerDiscounts);
            await _dbContext.SaveChangesAsync();

            return _mapper.Map<List<OfferDiscount>, List<OfferDiscountResponse>>(offerDiscounts);
        }
    }
}
