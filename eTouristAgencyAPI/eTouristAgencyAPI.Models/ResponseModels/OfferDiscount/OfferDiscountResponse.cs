using eTouristAgencyAPI.Models.ResponseModels.EntityCodeValue;

namespace eTouristAgencyAPI.Models.ResponseModels.OfferDiscount
{
    public class OfferDiscountResponse
    {
        public Guid Id { get; set; }

        public Guid DiscountTypeId { get; set; }

        public decimal Discount { get; set; }

        public DateTime ValidFrom { get; set; }

        public DateTime ValidTo { get; set; }

        public EntityCodeValueResponse DiscountType { get; set; }

        public bool IsEditable { get; set; }

        public bool IsRemovable { get; set; }
    }
}
