using eTouristAgencyAPI.Models.RequestModels.Offer;
using eTouristAgencyAPI.Models.ResponseModels;
using eTouristAgencyAPI.Models.ResponseModels.Offer;
using eTouristAgencyAPI.Models.SearchModels;
using eTouristAgencyAPI.Services.Constants;
using eTouristAgencyAPI.Services.Database;
using eTouristAgencyAPI.Services.Database.Models;
using eTouristAgencyAPI.Services.Interfaces;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;

namespace eTouristAgencyAPI.Services
{
    public class OfferWriteService : CRUDService<Offer, OfferResponse, OfferSearchModel, AddOfferRequest, UpdateOfferRequest>, IOfferWriteService
    {
        private readonly Guid? _userId;

        public OfferWriteService(eTouristAgencyDbContext dbContext,
                                 IMapper mapper,
                                 IUserContextService userContextService) : base(dbContext, mapper)
        {
            _userId = userContextService.GetUserId();
        }

        protected override async Task BeforeInsertAsync(AddOfferRequest insertModel, Offer dbModel)
        {
            ValidateInsertModel(insertModel);

            dbModel.Id = Guid.NewGuid();
            dbModel.CreatedBy = _userId ?? Guid.Empty;
            dbModel.ModifiedBy = _userId ?? Guid.Empty;
            dbModel.OfferStatusId = AppConstants.FixedOfferStatusDraft;

            dbModel.OfferImage = new OfferImage
            {
                ImageBytes = insertModel.OfferImageBytes,
                ImageName = insertModel.OfferImageName,
                CreatedBy = _userId ?? Guid.Empty,
                ModifiedBy = _userId ?? Guid.Empty
            };

            if (insertModel.OfferDocumentBytes != null)
            {
                dbModel.OfferDocument = new OfferDocument
                {
                    DocumentBytes = insertModel.OfferDocumentBytes,
                    DocumentName = insertModel.OfferDocumentName,
                    CreatedBy = _userId ?? Guid.Empty,
                    ModifiedBy = _userId ?? Guid.Empty
                };
            }
        }

        private void ValidateInsertModel(AddOfferRequest insertModel)
        {
            #region Offer Validation
            if (insertModel.TripStartDate.Date <= DateTime.Now.Date)
            {
                throw new Exception("Datum polaska mora biti nakon današnjeg datuma.");
            }

            if (insertModel.TripEndDate.Date <= insertModel.TripStartDate.Date)
            {
                throw new Exception("Datum povratka mora biti nakon datuma odlaska.");
            }

            if (insertModel.FirstPaymentDeadline.Date >= insertModel.TripStartDate.Date)
            {
                throw new Exception("Krajnji datum za uplatu prve rate mora biti prije datuma polaska.");
            }

            if (insertModel.LastPaymentDeadline.Date < insertModel.FirstPaymentDeadline.Date)
            {
                throw new Exception("Krajnji datum za uplatu zadnje rate ne smije biti prije krajnjeg datuma za uplatu prve rate");
            }
            #endregion

            #region Discount Validation
            if (insertModel.DiscountList.Where(x => x.DiscountTypeId == AppConstants.FixedOfferDiscountTypeFirstMinute).Count() > 1 ||
                insertModel.DiscountList.Where(x => x.DiscountTypeId == AppConstants.FixedOfferDiscountTypeLastMinute).Count() > 1)
                throw new Exception("You can provide only one first minute and last minute discount.");

            foreach (var discount in insertModel.DiscountList)
            {
                if (discount.ValidFrom.Date <= DateTime.Now.Date)
                {
                    throw new Exception("Datum početka novog popusta mora biti nakon današnjeg datuma.");
                }

                if (discount.ValidTo.Date < discount.ValidFrom.Date)
                {
                    throw new Exception("Datum završetka novog popusta ne smije biti prije datuma početka novog popusta.");
                }
            }

            if (insertModel.DiscountList.Count > 1)
            {
                var firstMinute = insertModel.DiscountList.Find(x => x.DiscountTypeId == AppConstants.FixedOfferDiscountTypeFirstMinute);
                var lastMinute = insertModel.DiscountList.Find(x => x.DiscountTypeId == AppConstants.FixedOfferDiscountTypeLastMinute);

                if (lastMinute.ValidFrom.Date <= firstMinute.ValidTo.Date)
                {
                    throw new Exception("Last minute popust mora biti nakon first minute popusta.");
                }
            }
            #endregion
        }

        public override Task<PaginatedList<OfferResponse>> GetAllAsync(OfferSearchModel searchModel)
        {
            throw new NotImplementedException();
        }

        public override Task<OfferResponse> GetByIdAsync(Guid id)
        {
            throw new NotImplementedException();
        }

        protected override async Task BeforeUpdateAsync(UpdateOfferRequest updateModel, Offer dbModel)
        {
            await ValidateUpdateModelAsync(updateModel, dbModel);

            dbModel.ModifiedOn = DateTime.Now;
            dbModel.ModifiedBy = _userId ?? Guid.Empty;

            if (updateModel.OfferDocumentBytes != null)
            {
                if (dbModel.OfferDocument != null)
                {
                    dbModel.OfferDocument.DocumentBytes = updateModel.OfferDocumentBytes;
                    dbModel.OfferDocument.DocumentName = updateModel.OfferDocumentName;
                    dbModel.OfferDocument.ModifiedBy = _userId ?? Guid.Empty;
                    dbModel.OfferDocument.ModifiedOn = DateTime.Now;
                }
                else
                {
                    dbModel.OfferDocument = new OfferDocument
                    {
                        DocumentBytes = updateModel.OfferDocumentBytes,
                        DocumentName = updateModel.OfferDocumentName,
                        CreatedBy = _userId ?? Guid.Empty,
                        ModifiedBy = _userId ?? Guid.Empty
                    };
                }
            }
            else
            {
                if (dbModel.OfferDocument != null)
                {
                    _dbContext.OfferDocuments.Remove(dbModel.OfferDocument);
                    await _dbContext.SaveChangesAsync();
                }
            }

            if (dbModel.OfferImage != null)
            {
                dbModel.OfferImage.ImageBytes = updateModel.OfferImageBytes;
                dbModel.OfferImage.ImageName = updateModel.OfferImageName;
                dbModel.OfferImage.ModifiedBy = _userId ?? Guid.Empty;
                dbModel.OfferImage.ModifiedOn = DateTime.Now;
            }
            else
            {
                dbModel.OfferImage = new OfferImage
                {
                    ImageBytes = updateModel.OfferImageBytes,
                    ImageName = updateModel.OfferImageName,
                    CreatedBy = _userId ?? Guid.Empty,
                    ModifiedBy = _userId ?? Guid.Empty
                };
            }
        }

        private async Task ValidateUpdateModelAsync(UpdateOfferRequest updateModel, Offer dbModel)
        {
            #region Offer Validation
            if (dbModel.TripStartDate.Date <= DateTime.Now.Date)
            {
                throw new Exception("Currently, you cannot update offer.");
            }

            if (updateModel.TripStartDate.Date <= DateTime.Now.Date)
            {
                throw new Exception("Datum polaska mora biti nakon današnjeg datuma.");
            }

            if (updateModel.TripEndDate.Date <= updateModel.TripStartDate.Date)
            {
                throw new Exception("Datum povratka mora biti nakon datuma odlaska.");
            }

            if (updateModel.FirstPaymentDeadline.Date >= updateModel.TripStartDate.Date)
            {
                throw new Exception("Krajnji datum za uplatu prve rate mora biti prije datuma polaska.");
            }

            if (updateModel.LastPaymentDeadline.Date < updateModel.FirstPaymentDeadline.Date)
            {
                throw new Exception("Krajnji datum za uplatu zadnje rate ne smije biti prije krajnjeg datuma za uplatu prve rate");
            }
            #endregion

            #region Discount Validation
            if (updateModel.DiscountList.Where(x => x.DiscountTypeId == AppConstants.FixedOfferDiscountTypeFirstMinute).Count() > 1 ||
                updateModel.DiscountList.Where(x => x.DiscountTypeId == AppConstants.FixedOfferDiscountTypeLastMinute).Count() > 1)
                throw new Exception("You can provide only one first minute and last minute discount.");

            if (updateModel.DiscountList.Count > 1)
            {
                var firstMinute = updateModel.DiscountList.Find(x => x.DiscountTypeId == AppConstants.FixedOfferDiscountTypeFirstMinute);
                var lastMinute = updateModel.DiscountList.Find(x => x.DiscountTypeId == AppConstants.FixedOfferDiscountTypeLastMinute);

                if (lastMinute.ValidFrom.Date <= firstMinute.ValidTo.Date)
                {
                    throw new Exception("Last minute popust mora biti nakon first minute popusta.");
                }
            }

            var discounts = await _dbContext.OfferDiscounts.Where(x => x.OfferId == dbModel.Id).ToListAsync();
            var startedDiscounts = discounts.Where(x => x.ValidFrom.Date <= DateTime.Now.Date).ToList();

            foreach (var discount in startedDiscounts)
            {
                var providedDiscount = updateModel.DiscountList.FirstOrDefault(x => x.Id == discount.Id);

                if (providedDiscount == null)
                {
                    throw new Exception("Nije moguće obrisati popust koji je u toku ili je završen.");
                }

                if (providedDiscount.ValidFrom.Date != discount.ValidFrom.Date)
                {
                    throw new Exception("Nije moguće mijenjati datum početka popusta ukoliko je isti u toku ili je završio.");
                }

                if (discount.Discount != providedDiscount.Discount)
                {
                    throw new Exception("Nije moguće mijenjati vrijednost popusta ukoliko je isti u toku ili je završio.");
                }

                if (discount.ValidTo.Date < DateTime.Now.Date)
                {
                    if (discount.ValidTo.Date != providedDiscount.ValidTo.Date)
                    {
                        throw new Exception("Nije moguće promijeniti datum završetka popusta ukoliko je isti završio.");
                    }
                }
                else
                {
                    if (providedDiscount.ValidTo.Date < DateTime.Now.Date)
                    {
                        throw new Exception("Nije moguće promijeniti datum završetka aktivnog popusta na datum prije današnjeg.");
                    }
                }
            }

            foreach (var discount in updateModel.DiscountList.Where(x => !startedDiscounts.Select(x => x.Id).Contains(x.Id ?? Guid.Empty)))
            {
                if (discount.ValidFrom.Date <= DateTime.Now.Date)
                {
                    throw new Exception("Datum početka novog popusta mora biti nakon današnjeg datuma.");
                }

                if (discount.ValidTo.Date < discount.ValidFrom.Date)
                {
                    throw new Exception("Datum završetka novog popusta ne smije biti prije datuma početka novog popusta.");
                }
            }
            #endregion
        }

        protected override async Task<IQueryable<Offer>> BeforeFetchRecordAsync(IQueryable<Offer> queryable)
        {
            queryable = queryable.Include(x => x.OfferImage).Include(x => x.OfferDocument).Include(x => x.OfferStatus).Include(x => x.BoardType).Include(x => x.Hotel);

            return queryable;
        }
    }
}