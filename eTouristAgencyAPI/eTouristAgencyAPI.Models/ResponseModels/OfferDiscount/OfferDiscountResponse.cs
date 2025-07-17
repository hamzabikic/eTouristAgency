namespace eTouristAgencyAPI.Models.ResponseModels.OfferDiscount
{
    public class OfferDiscountResponse
    {
        public Guid Id { get; set; }

        public Guid DiscountTypeId { get; set; }

        public decimal Discount { get; set; }

        public DateTime ValidFrom { get; set; }

        public DateTime ValidTo { get; set; }
    }
}
