namespace eTouristAgencyAPI.Models.SearchModels
{
    public class OfferSearchModel : PaginationModel
    {
        public string? OfferNo { get; set; }
        public Guid? CountryId { get; set; }
        public Guid? OfferStatusId { get; set; }
        public decimal? OfferPriceFrom { get; set; }
        public decimal? OfferPriceTo { get; set; }
        public Guid? BoardTypeId { get; set; }
        public DateTime? OfferDateFrom { get; set; }
        public DateTime? OfferDateTo { get; set; }
    }
}
