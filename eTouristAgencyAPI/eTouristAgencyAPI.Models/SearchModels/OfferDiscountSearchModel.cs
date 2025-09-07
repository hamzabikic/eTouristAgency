using System.ComponentModel.DataAnnotations;

namespace eTouristAgencyAPI.Models.SearchModels
{
    public class OfferDiscountSearchModel : PaginationModel
    {
        [Required]
        public Guid OfferId { get; set; }
    }
}