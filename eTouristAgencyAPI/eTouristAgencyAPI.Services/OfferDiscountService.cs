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

        public async Task<List<OfferDiscountResponse>> UpdateAsync(Guid offerId, List<UpdateOfferDiscountRequest> offerDiscountList)
        {
            if (offerDiscountList.Where(x => x.DiscountTypeId == AppConstants.FixedOfferDiscountTypeFirstMinute).Count() > 1 ||
                offerDiscountList.Where(x => x.DiscountTypeId == AppConstants.FixedOfferDiscountTypeLastMinute).Count() > 1)
                throw new Exception("You can provide only one first minute and last minute discount.");

            var existingDiscounts = await _dbContext.OfferDiscounts.Include(x => x.Offer).Where(x => x.OfferId == offerId).ToListAsync();
            var discountForUpdate = existingDiscounts.Where(x => offerDiscountList.Select(y => y.Id).Contains(x.Id) && x.ValidFrom > DateTime.Now || x.Offer.OfferStatusId == AppConstants.FixedOfferStatusDraft).ToList();
            var discountsForDelete = existingDiscounts.Where(x => !offerDiscountList.Select(y => y.Id).Contains(x.Id) && x.ValidFrom > DateTime.Now || x.Offer.OfferStatusId == AppConstants.FixedOfferStatusDraft).ToList();
            var discountsForInsert = _mapper.Map<List<OfferDiscount>>(offerDiscountList.Where(x => x.Id == null && !existingDiscounts.Any(y => y.DiscountTypeId == x.DiscountTypeId)).ToList());

            foreach (var item in discountsForInsert)
            {
                item.Id = Guid.NewGuid();
                item.CreatedBy = _userId ?? Guid.Empty;
                item.ModifiedBy = _userId ?? Guid.Empty;
                item.OfferId = offerId;
            }

            foreach (var item in discountForUpdate)
            {
                item.ModifiedBy = _userId ?? Guid.Empty;
                item.ModifiedOn = DateTime.Now;
                item.OfferId = offerId;

                _mapper.Map<UpdateOfferDiscountRequest, OfferDiscount>(offerDiscountList.FirstOrDefault(x => x.Id == item.Id), item);
            }

            await _dbContext.OfferDiscounts.AddRangeAsync(discountsForInsert);
            _dbContext.OfferDiscounts.RemoveRange(discountsForDelete);
            await _dbContext.SaveChangesAsync();

            var currentDiscounts = await _dbContext.OfferDiscounts.Include(x => x.DiscountType).Where(x => x.OfferId == offerId).ToListAsync();
            return _mapper.Map<List<OfferDiscount>, List<OfferDiscountResponse>>(currentDiscounts);
        }
    }
}
