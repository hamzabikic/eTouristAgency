namespace eTouristAgencyAPI.Models.RequestModels.OfferDiscount
{
    public class UpdateOfferDiscountRequest
    {
        public Guid Id { get; set; }

        public decimal Discount { get; set; }

        public DateTime ValidFrom { get; set; }

        public DateTime ValidTo { get; set; }
    }
}