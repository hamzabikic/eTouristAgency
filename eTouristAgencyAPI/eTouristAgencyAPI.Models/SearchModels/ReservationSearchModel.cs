namespace eTouristAgencyAPI.Models.SearchModels
{
    public class ReservationSearchModel : PaginationModel
    {
        public Guid? OfferId { get; set; }
        public Guid? ReservationStatusId { get; set; }
        public string? ReservationNoSearchText { get; set; }
    }
}
