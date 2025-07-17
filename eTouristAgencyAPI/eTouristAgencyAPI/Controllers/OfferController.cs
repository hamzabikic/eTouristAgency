using eTouristAgencyAPI.Models.RequestModels.Offer;
using eTouristAgencyAPI.Models.ResponseModels.Offer;
using eTouristAgencyAPI.Models.SearchModels;
using eTouristAgencyAPI.Services.Constants;
using eTouristAgencyAPI.Services.Database.Models;
using eTouristAgencyAPI.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eTouristAgencyAPI.Controllers
{
    public class OfferController : CRUDController<Offer, OfferResponse, OfferSearchModel, AddOfferRequest, UpdateOfferRequest>
    {
        public OfferController(IOfferService offerService) : base(offerService)
        {
        }

        [Authorize(Roles = Roles.Admin)]
        public override Task<ActionResult<OfferResponse>> Add([FromBody] AddOfferRequest insertModel)
        {
            return base.Add(insertModel);
        }

        [Authorize(Roles = Roles.Admin)]
        public override Task<ActionResult<OfferResponse>> Update(Guid id, [FromBody] UpdateOfferRequest updateModel)
        {
            return base.Update(id, updateModel);
        }
    }
}
