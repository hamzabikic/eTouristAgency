namespace eTouristAgencyAPI.Models.RequestModels.OfferDiscount
{
    public class AddOfferDiscountRequest
    {
        public Guid DiscountTypeId { get; set; }

        public decimal Discount { get; set; }

        public DateTime ValidFrom { get; set; }

        public DateTime ValidTo { get; set; }
    }
}