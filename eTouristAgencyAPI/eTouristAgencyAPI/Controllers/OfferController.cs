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
        private readonly IOfferService _offerService;

        public OfferController(IOfferService offerService) : base(offerService)
        {
            _offerService = offerService;
        }

        [Authorize(Roles = Roles.Admin)]
        public override Task<ActionResult> Add([FromBody] AddOfferRequest insertModel)
        {
            return base.Add(insertModel);
        }

        [Authorize(Roles = Roles.Admin)]
        public override Task<ActionResult> Update(Guid id, [FromBody] UpdateOfferRequest updateModel)
        {
            return base.Update(id, updateModel);
        }

        [Authorize(Roles = Roles.Admin)]
        [HttpPatch("{id}/activate")]
        public async Task<ActionResult> Activate(Guid id)
        {
            try
            {
                await _offerService.ActivateAsync(id);
                return Ok();
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [Authorize(Roles = Roles.Admin)]
        [HttpPatch("{id}/deactivate")]
        public async Task<ActionResult> Deactivate(Guid id)
        {
            try
            {
                await _offerService.DeactivateAsync(id);
                return Ok();
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [AllowAnonymous]
        [HttpGet("{id}/image")]
        public async Task<ActionResult> GetImage(Guid id)
        {
            try
            {
                var offerImage = await _offerService.GetImageByIdAsync(id);

                Response.Headers.Add("ImageName", offerImage.ImageName);
                return File(offerImage.ImageBytes, "application/octet-stream", offerImage.ImageName);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [HttpGet("{id}/document")]
        public async Task<ActionResult> GetDocument(Guid id)
        {
            try
            {
                var offerDocument = await _offerService.GetDocumentByIdAsync(id);

                Response.Headers.Add("DocumentName", offerDocument.DocumentName);
                return File(offerDocument.DocumentBytes, "application/octet-stream", offerDocument.DocumentName);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }
    }
}
