using eTouristAgencyAPI.Models.RequestModels.ReservationReview;
using eTouristAgencyAPI.Models.ResponseModels;
using eTouristAgencyAPI.Models.ResponseModels.ReservationReview;
using eTouristAgencyAPI.Models.SearchModels;
using eTouristAgencyAPI.Services.Constants;
using eTouristAgencyAPI.Services.Database.Models;
using eTouristAgencyAPI.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eTouristAgencyAPI.Controllers
{
    public class ReservationReviewController : CRUDController<ReservationReview, ReservationReviewResponse, ReservationReviewSearchModel, AddReservationReviewRequest, UpdateReservationReviewRequest>
    {
        public ReservationReviewController(IReservationReviewService reservationReviewService) : base(reservationReviewService)
        {

        }

        [Authorize(Roles = Roles.Client)]
        public override Task<ActionResult> Add([FromBody] AddReservationReviewRequest insertModel)
        {
            return base.Add(insertModel);
        }

        [Authorize(Roles = Roles.Admin)]
        public override Task<ActionResult<PaginatedList<ReservationReviewResponse>>> GetAll([FromQuery] ReservationReviewSearchModel searchModel)
        {
            return base.GetAll(searchModel);
        }

        [NonAction]
        public override Task<ActionResult> Update(Guid id, [FromBody] UpdateReservationReviewRequest updateModel)
        {
            return base.Update(id, updateModel);
        }
    }
}
