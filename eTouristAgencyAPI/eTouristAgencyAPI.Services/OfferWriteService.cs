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

        protected override async Task<IQueryable<Offer>> BeforeFetchRecordAsync(IQueryable<Offer> queryable)
        {
            queryable = queryable.Include(x => x.OfferImage).Include(x => x.OfferDocument).Include(x => x.OfferStatus).Include(x => x.BoardType).Include(x => x.Hotel);

            return queryable;
        }
    }
}
